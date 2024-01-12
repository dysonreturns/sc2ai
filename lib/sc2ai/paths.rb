# frozen_string_literal: true

require "tmpdir"

module Sc2
  # Helps determine common paths to sc2 install dir, executable and maps.
  # It maintains some semblance of compatibility with python-sc2 config
  #
  # ENV['SC2PATH'] can be set manually to Starcraft 2 base directory for Linux
  # ENV['SC2PF'] can and should be manually set to "WineLinux" when running Wine
  # Credit to Hannes, Sean and Burny for setting the standard
  class Paths
    # Platform name for Windows
    PF_WINDOWS = "Windows"
    # Platform name for WSL1
    PF_WSL1 = "WSL1"
    # Platform name for WSL2
    PF_WSL2 = "WSL2"
    # Platform name macOS
    PF_DARWIN = "Darwin"
    # Platform name Linux
    PF_LINUX = "Linux"
    # Platform name for Wine
    PF_WINE = "WineLinux"

    # Where within user directory to locate ExecuteInfo.txt
    BASE_DIR = {
      PF_WINDOWS => "C:/Program Files (x86)/StarCraft II",
      PF_WSL1 => "/mnt/c/Program Files (x86)/StarCraft II",
      PF_WSL2 => "/mnt/c/Program Files (x86)/StarCraft II",
      PF_DARWIN => "/Applications/StarCraft II",
      PF_LINUX => "~/StarCraftII",
      PF_WINE => "~/.wine/drive_c/Program Files (x86)/StarCraft II"
    }.freeze

    # Where within user directory to locate ExecuteInfo.txt
    EXEC_INFO_PATH = {
      PF_WINDOWS => "Documents/StarCraft II/ExecuteInfo.txt",
      PF_WSL1 => "Documents/StarCraft II/ExecuteInfo.txt",
      PF_WSL2 => "Documents/StarCraft II/ExecuteInfo.txt",
      PF_DARWIN => "Library/Application Support/Blizzard/StarCraft II/ExecuteInfo.txt",
      PF_LINUX => nil,
      PF_WINE => nil
    }.freeze

    # Path helper for finding executable
    BIN_PATH = {
      PF_WINDOWS => "SC2_x64.exe",
      PF_WSL1 => "SC2_x64.exe",
      PF_WSL2 => "SC2_x64.exe",
      PF_DARWIN => "SC2.app/Contents/MacOS/SC2",
      PF_LINUX => "SC2_x64",
      PF_WINE => "SC2_x64.exe"
    }.freeze

    # Working directory sub-folder per platform.
    # Used when spawning client process on some platforms.
    WORKING_DIR = {
      PF_WINDOWS => "Support64",
      PF_WSL1 => "Support64",
      PF_WSL2 => "Support64",
      PF_DARWIN => nil,
      PF_LINUX => nil,
      PF_WINE => "Support64"
    }.freeze

    class << self
      # An array of available platforms
      # @return [Array<String>] an array of valid platforms
      def platforms
        [PF_WINDOWS, PF_WSL1, PF_WSL2, PF_DARWIN, PF_LINUX, PF_WINE]
      end

      # Bucketed platform names follows convention
      # Uses ENV['SC2PF'] if configured. This is the only way to set "WineLinux"
      # @return ["Windows","WSL1","WSL2","Darwin","Linux","WineLinux"] string platform name
      def platform
        return ENV.fetch("SC2PF", nil) unless ENV["SC2PF"].to_s.strip.empty?

        if Gem.win_platform?
          ENV["SC2PF"] = PF_WINDOWS
        elsif Gem::Platform.local.os == "darwin"
          ENV["SC2PF"] = PF_DARWIN
        elsif Gem::Platform.local.os == "linux"
          ENV["SC2PF"] = PF_LINUX
          if wsl?
            ENV["SC2PF"] = wsl2? ? PF_WSL2 : PF_WSL1
          end
        end

        unless ENV.fetch("SC2PF", false)
          Sc2.logger.warn "unknown platform detected #{Gem::Platform.local.os}. manually set ENV['SC2PF']"
        end
        ENV.fetch("SC2PF", nil)
      end

      # Attempts to auto-detect the user's install directory via ExecuteInfo.txt
      #   SC2PATH is required on WineLinux and Linux
      # @return [String] path
      def install_dir
        if ENV.fetch("SC2PATH", false)
          # Use if set via environment
          path = ENV.fetch("SC2PATH")
        else
          # Otherwise try read from ExecuteInfo.txt
          path = read_exec_info
          if path.to_s.strip.empty?
            # If not present in ExecuteInfo, try use sensible default
            path = BASE_DIR[platform]
          end
        end
        path = File.expand_path(path) if platform != PF_WINDOWS

        ENV["SC2PATH"] = path
      end

      # Replays directory based on install_dir
      # @return [String] replays directory
      def replay_dir
        Pathname(install_dir).join("Replays").to_s
      end

      # Maps directory based on install_dir
      # @return [String] maps directory
      def maps_dir
        # Use Maps if exists, or as fallback if alternative not found
        dir = Pathname(install_dir).join("Maps")
        return dir.to_s if dir.exist?

        # Use lowercase "maps" only if it exists
        dir_alt = Pathname(install_dir).join("maps")
        dir = dir_alt if dir_alt.exist?

        dir.to_s
      end

      # Working directory if required by platform
      # Some platforms the correct working directory for launch to find linked libraries
      # @return [String,nil] string path or nil if not required
      def exec_working_dir
        cwd = WORKING_DIR[platform]
        return nil if cwd.nil?

        Pathname(install_dir).join(cwd).to_s
      end

      # Gets a path to latest Sc2 executable, or specific build's executable if defined
      # @param base_build [Integer, nil] version to use if installed
      # @return [String, nil] path to executable
      # noinspection RubyMismatchedReturnType
      def executable(base_build: nil)
        # Use base_build if supplied
        unless base_build.nil?
          path = Pathname.new(version_dir).join("Base#{base_build}")
          return path.join(BIN_PATH[platform]).to_s if path.exist?
        end
        # Get highest build number for folders /^Base\d$/
        pattern = /Base(\d+)$/
        path = Pathname.new(version_dir).glob("Base*")
          .max { |a, b| a.to_s.match(pattern)[1] <=> b.to_s.match(pattern)[1] }
        return path.join(BIN_PATH[platform]).to_s if path&.exist?

        nil
      end

      # Returns project root directory
      # @return [String] path because bundler does.
      def project_root_dir
        return Bundler.root.to_s if defined?(Bundler)

        Dir.pwd
      end

      # For local and ladder play, your files modified at runtime should live in ./data
      # @return [String] path to ./data
      def bot_data_dir
        dir = Pathname("./data")
        dir.mkdir unless dir.exist?
        dir.to_s
      end

      # Returns the local replay folder
      # For local play, your replay filse are saved to ./data/replays
      # @return [String] path to ./data/replays
      def bot_data_replay_dir
        dir = Pathname(bot_data_dir).join("replays")
        dir.mkdir unless dir.exist?
        dir.to_s
      end

      # @private
      # Root directory of gem itself for other bundled files
      # @return [Pathname] path to gem folder which contains lib/,data/,etc.
      def gem_root
        Pathname.new(__dir__.to_s).parent.parent.expand_path
      end

      # @private
      # Path to shipped versions.json
      # @return [Pathname] path
      def gem_data_versions_path
        Pathname.new(gem_root).join("data", "versions.json")
      end

      # Gets system temp directory and creates /sc2ai
      # @return [String] temporary directory for use with -tempDir
      def generate_temp_dir
        temp_dir = Pathname(Dir.tmpdir).join("sc2ai").mkpath
        temp_dir.to_s
      end

      # Checks if running WSL
      # @return [Boolean]
      def wsl?
        Gem::Platform.local.os == "linux" && (ENV.fetch("IS_WSL", false) || ENV.fetch("WSL_DISTRO_NAME", false))
      end

      # Checks if running WSL2 specifically on top of wsl? being true
      # @return [Boolean]
      def wsl2?
        wsl? && ENV.fetch("WSL_INTEROP", false)
      end

      # Convert a path like "C:\\path\\To a\\Location" to "/mnt/c/path/To a/Location"
      # @param path [String]
      # @return [String] path converted
      def win_to_wsl(path:)
        "/mnt/" + path.sub(/\A([A-Z])(:)/) { ::Regexp.last_match(1).to_s.downcase }.tr("\\", "/")
      end

      # Convert a path like "/mnt/c/path/To a/Location" to "C:\\path\\To a\\Location"
      # @param path [String]
      # @return [String] path converted
      def wsl_to_win(path:)
        path.sub(%r{\A/mnt/([a-z])}) { "#{::Regexp.last_match(1).to_s.upcase}:" }.tr("/", "\\")
      end

      private

      # Versions directory based on install_dir
      # @return [String] install_dir + "/Versions"
      def version_dir
        Pathname(install_dir).join("Versions").to_s
      end

      # Loads version data
      # @return [JSON] versions.json
      def version_json
        JSON.load_file(Pathname(__dir__.to_s).join("../data/versions.json"))
      end

      # Reads contents for ExecuteInfo.txt
      # @return [String] contents of exec_info or empty string
      def read_exec_info
        return "" unless EXEC_INFO_PATH[platform]

        # Read path ExecuteInfo.txt
        exec_info_path = File.join(Dir.home, EXEC_INFO_PATH[platform])
        content = File.read(exec_info_path)
        dir = content.match(/ = (.*)Versions/)[1].to_s

        # Platform-specific patches
        if platform == PF_WSL1 || platform == PF_WSL2
          dir = win_to_wsl(path: dir)
          raise Pathname(dir).inspect
        elsif PF_WINDOWS
          dir = dir.tr("\\", "/")
        end

        dir = dir.chomp("\\").chomp("/")
        return dir if File.exist?(dir)
      rescue
        ""
      else
        ""
      end

      # # Access singleton via Paths.instance
      # private
      #
      # def instance
      #   @_instance ||= new(self.platform)
      # end
    end
  end
end
