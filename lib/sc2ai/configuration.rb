# frozen_string_literal: true

require "yaml"
require "pathname"
require_relative "local_play/client/configurable_options"

module Sc2
  # Global config manager for runtime
  # @example Manual configuration block
  #   Sc2.config do |config|
  #     config.sc2_platform = "WineLinux"
  #     config.sc2_path = "/c/Program Files (x86)/StarCraft II/"
  #     config.ports = [5001,5002,5003]
  #     config.host = '127.0.0.1'
  #   end
  class Configuration
    # Include client launch options
    include Sc2::Client::ConfigurableOptions

    # Attributes permitted to be read and save from config yaml
    CONFIG_ATTRIBUTES = %i[
      sc2_platform
      sc2_path
      version
      ports
      host
      display_mode
      windowwidth
      windowheight
      windowx
      windowy
      verbose
      data_dir
      temp_dir
      egl_path
      osmesa_path
    ].freeze

    # @!attribute sc2_platform
    # Sc2 platform config alias will override ENV["SC2PF"]
    #   @return [String] (see Sc2::Paths#platform)
    attr_accessor :sc2_platform

    # @!attribute sc2_path
    #   Sc2 Path config alias will override ENV["SC2PATH"]
    #   @return [String] sc2_path (see Sc2::Paths#platform)
    attr_accessor :sc2_path

    # @!attribute ports
    #   if empty, a random port will be picked when launching
    #   Launch param: -listen
    #   @return [Array<Integer>]
    attr_accessor :ports

    # Create a new Configuration and sets defaults and loads config from yaml
    # @return [Sc2::Configuration]
    def initialize
      set_defaults

      load_config(config_file) if config_file.exist?

      # create temp dir on linux
      ensure_temp_dir
    end

    # Config file location
    # @return [Pathname] path
    def config_file
      # Pathname(Paths.project_root_dir).join("config", "sc2ai.yml")
      Pathname(Paths.project_root_dir).join("sc2ai.yml")
    end

    # Sets defaults when initializing
    # @return [void]
    def set_defaults
      @sc2_platform = Paths.platform
      @sc2_path = Paths.install_dir
      @ports = []

      load_default_launch_options
    end

    # Writes this instance's attributes to yaml config_file
    # @return [void]
    def save_config
      # config_file.dirname.mkpath unless config_file.dirname.exist?
      config_file.write(to_yaml.to_s)
      nil
    end

    # Converts attributes to yaml
    # @return [Hash] yaml matching stringified keys from CONFIG_ATTRIBUTES
    def to_yaml
      to_h.to_yaml
    end

    # Converts attributes to hash
    # @return [Hash] hash matching stringified keys from CONFIG_ATTRIBUTES
    def to_h
      CONFIG_ATTRIBUTES.map do |name|
        [name.to_s, instance_variable_get(:"@#{name}")]
      end.to_h
    end

    # Loads YAML config
    # @param file [Pathname,String] location of config file
    # @return [Boolean] success/failure
    def load_config(file)
      file = Pathname(file) unless file.is_a? Pathname
      return false if !file.exist? || file.size.nil?

      begin
        content = ::Psych.safe_load(file.read)
        unless content.is_a? Hash
          Sc2.logger.warn "Failed to load #{file} because it doesn't contain valid YAML hash"
          return false
        end
        CONFIG_ATTRIBUTES.map(&:to_s).each do |attribute|
          next unless content.key?(attribute.to_s)

          instance_variable_set(:"@#{attribute}", content[attribute])
        end
        return true
      rescue ArgumentError, Psych::SyntaxError => e
        Sc2.logger.warn "Failed to load #{file}, #{e}"
      rescue Errno::EACCES
        Sc2.logger.warn "Failed to load #{file} due to permissions problem."
      end

      false
    end

    private

    # Makes sure we have a temporary directory on linux if not specified
    # @return [void]
    def ensure_temp_dir
      return unless Paths.platform == Paths::PF_LINUX

      return unless @temp_dir.to_s.empty?

      @temp_dir = Paths.generate_temp_dir
    end
  end
end
