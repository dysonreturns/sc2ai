# frozen_string_literal: true

module Sc2
  # Helps easily locate a map and fetch input for Api::LocalMap
  class MapFile
    # File extension used for maps
    EXTENSION = ".SC2Map"

    # @!attribute [r] path
    #   @return [String] path map location for use in LocalMap.map_path
    attr_reader :path

    # Accepts a map file name and initializes a local map object
    # @example
    #   map = Sc2::Map.new("2000AtmospheresAIE")
    #   map = Sc2::Map.new("2000AtmospheresAIE.SC2Map")
    #   map = Sc2::Map.new("/absolute/path/to/2000AtmospheresAIE.SC2Map")
    #   # If within your Sc2 Maps folder, you have a sub-folder "sc2ai_2022_season3"
    #   map = Sc2::Map.new("sc2ai_2022_season3/2000AtmospheresAIE.SC2Map")
    # @param name [String] absolute path or path relative to maps
    def initialize(name)
      raise Error if name.empty?

      name = "#{name}#{EXTENSION}" unless name.end_with? EXTENSION

      @path = name.to_s
      return if Pathname(name).absolute?

      @path = Pathname(Paths.maps_dir).glob("**/#{name}").first.to_s
      if Paths.wsl?
        @path = Paths.wsl_to_win(path: @path)
      end
    end

    # Returns contents of map file for user with LocalMap.map_data
    # @return [String, nil] contents of file
    def data
      file = Pathname(@path)
      return file.read if file.exist?

      nil
    end

    private

    attr_writer :path
  end
end
