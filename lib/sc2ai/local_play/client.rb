# frozen_string_literal: true

require_relative "client/configurable_options"

module Sc2
  # Manages client connection to the Api
  class Client
    include Sc2::Client::ConfigurableOptions

    # @!attribute port
    # Sc2 port param on which to listen for connections, default is randomly selected<br>
    # Launch param: -port 12345
    # @return [Integer]
    attr_accessor :port

    # @!attribute base_build
    # Sc2 build number determines where to look for correct executable version binary
    # @return [Integer]
    attr_accessor :base_build

    # @!attribute data_version
    # Sc2 data param, typically only required when launching older versions and Linux
    # Launch param: -dataVersion "B89B5D6FA7CBF6452E721311BFBC6CB2"
    # @return [String]
    attr_accessor :data_version

    # Whether the Sc2 process is running or not
    # @return [Boolean]
    def running?
      !!@task&.running?
    end

    # Initialize new Sc2 client (starts with #launch)
    # @param host [String] to listen on, i.e. "0.0.0.0", "127.0.0.1"
    # @param port [Integer] 5001
    # @param options [Hash] (see Sc2::Client::ConfigurableOptions)
    def initialize(host:, port:, **options)
      raise Error, "Invalid port: #{port}" if port.to_s.empty?

      load_default_launch_options
      options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end

      # Require these at a minimum
      @port = port
      @host = host
      return if @version.nil?

      use_version(@version.to_s)
    end

    # Launches and returns pid or proc
    def launch
      cwd = Paths.exec_working_dir
      @task = Async do |task|
        options = {}

        if Gem.win_platform?
          options[:new_pgroup] = true
        else
          options[:pgroup] = true
        end
        unless cwd.nil?
          options[:chdir] = cwd
        end
        begin
          ::Async::Process.spawn(command_string, **options)
        rescue
          Sc2.logger.info("Client exited unexpectedly")
          task&.stop
        end
      end
    end

    # Stops the Sc2 instance<br/>
    # This naturally disconnects attached players too
    # @return [void]
    def stop
      @task&.stop
    end

    # Reads "base-version" and "data-hash" for corresponding version
    # @example
    #   client.base_build => nil
    #   client.data_version => nil
    #   client.use_version("4.10")
    #   client.base_build => 75689
    #   client.data_version => "B89B5D6FA7CBF6452E721311BFBC6CB2"
    # @param version [String]
    # return [Array<Integer,String>] tuple base_build and data_version
    def use_version(version)
      found_base_build = nil
      found_data_version = nil
      versions_json.each do |node|
        version_clean = version.gsub(".#{node["base-version"]}", "")
        if version_clean == node["label"]
          found_base_build = node["base-version"]
          found_data_version = node["data-hash"]
          @version = version_clean
          break
        end
      end
      if found_base_build.nil? || found_data_version.nil?
        Sc2.logger.warn "Requested version #{version} not found. Omit to auto-discover latest installed version"
        return false
      end

      @base_build = found_base_build
      @data_version = found_data_version
      true
    end

    private

    # @!attribute task
    # The async task running Sc2. Used when interrupting.
    # @return [Async::Task]
    attr_accessor :task

    # @private
    # Takes all configuration and Sc2 executable string with arguments
    # @return [String] command to launch Sc2
    def command_string
      command = "\"#{Sc2::Paths.executable(base_build: @base_build)}\" "
      command += " -port #{@port}"
      if Paths.platform == Paths::PF_WSL2
        # For WSL2, always let windows listen on all 0.0.0.0
        #   and let the ws connect @host which is the internal bridged windows ip
        command += " -listen 0.0.0.0"
      else
        command += " -listen #{@host}" unless @host.nil?
      end

      command += " -dataVersion #{@data_version}" unless @data_version.nil?
      command += " -verbose" if @verbose

      command += " -displayMode #{@display_mode}" unless @display_mode.nil?
      command += " -windowwidth #{@windowwidth}" unless @windowwidth.nil?
      command += " -windowheight #{@windowheight}" unless @windowheight.nil?
      command += " -windowx #{@windowx}" unless @windowx.nil?
      command += " -windowy #{@windowy}" unless @windowy.nil?

      command += " -dataDir #{@data_dir}" unless @data_dir.nil?
      command += " -tempDir #{@temp_dir}" unless @temp_dir.nil?
      command += " -eglpath #{@egl_path}" unless @egl_path.nil?
      command += " -osmesapath #{@osmesa_path}" unless @osmesa_path.nil?

      command
    end

    # @private
    # Reads bundled versions.json
    # @return [JSON] contents of versions.json
    def versions_json
      JSON.load_file(Paths.gem_data_versions_path)
    end
  end
end
