# frozen_string_literal: true

module Sc2
  class Client
    # Attributes shared by Configuration and Client
    module ConfigurableOptions
      # @!attribute host
      # Sc2 host param on which to listen for connections, default '0.0.0.0'
      #
      # Launch param: -host 0.0.0.0
      # @return [String,nil]
      attr_accessor :host

      # @!attribute data_dir
      # Override the path to find the data package.
      #
      # Required if the binary is not in the standard versions folder location.
      #
      # Launch param: -dataDir ../../
      # @return [String,nil]
      attr_accessor :data_dir

      # @!attribute verbose
      # If set to true, will send param to client.
      #
      # Enables logging of all protocol requests/responses to std::err.
      #
      # Launch param: -verbose
      # @return [Boolean]
      attr_accessor :verbose

      # @!attribute temp_dir
      # Override the path if you really need to set your own temp dir
      #
      # Implicit default is /tmp/
      #
      # Launch param: -tempDir ../../
      # @return [String,nil]
      attr_accessor :temp_dir

      # @!attribute egl_path
      # Sets the path the to hardware rendering library.
      #
      # Required for using the rendered interface with hardware rendering
      #
      # Launch param: -eglpath
      #
      # Example: /usr/lib/nvidia-384/libEGL.so
      # @return [String,nil]
      attr_accessor :egl_path

      # @!attribute osmesa_path
      # Sets the path the to software rendering library.
      #
      # Required for using the rendered interface with software rendering
      #
      # Launch param: -eglpath
      #
      # Example: /usr/lib/x86_64-linux-gnu/libOSMesa.so
      # @return [String,nil]
      attr_accessor :osmesa_path

      # @!attribute display_mode
      # Launch param: -displayMode
      # @return [0,1,nil] 0 for window, 1 for fullscreen, nil for system default
      attr_accessor :display_mode
      # @!attribute windowwidth
      # pixel width of game window
      # @return [Integer]
      attr_accessor :windowwidth # -windowwidth
      # @!attribute windowheight
      # pixel height of game window
      # @return [Integer]
      attr_accessor :windowheight # -windowheight
      # @!attribute windowx
      # left position of window if windowed
      # @return [Integer]
      attr_accessor :windowx # -windowx
      # @!attribute windowy
      # top position of window if windowed
      # @return [Integer]
      attr_accessor :windowy # -windowy

      # @!attribute version
      # Version number such as "4.10". Leave blank to use latest
      # @return [String,nil]
      attr_accessor :version

      # Resets configurable launch options to their defaults
      def load_default_launch_options
        @host = "0.0.0.0" # -listen
        if Paths.wsl?
          @host = "#{Socket.gethostname}.mshome.net"
        elsif Gem.win_platform?
          @host = "127.0.0.1"
        end

        @display_mode = 0 # -displayMode
        @windowwidth = nil # -windowwidth
        @windowheight = nil # -windowheight
        @windowx = nil # -windowx
        @windowy = nil # -windowy
        @verbose = false # -verbose

        # Linux
        @data_dir = nil # -dataDir '../../'
        @temp_dir = nil # -tempDir '/tmp/'
        @egl_path = nil # -eglpath '/usr/lib/nvidia-384/libEGL.so'
        @osmesa_path = nil # -osmesapath '/usr/lib/x86_64-linux-gnu/libOSMesa.so'

        @version = nil # calculates -dataVersion and Base% executable
      end
    end
  end
end
