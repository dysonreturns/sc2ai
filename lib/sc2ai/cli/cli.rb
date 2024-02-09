require "thor"
require "sc2ai/cli/new"
require "sc2ai/cli/ladderzip"

module Sc2
  # Command line utilities
  # standard:disable Style/GlobalVars
  class Cli < Thor
    # Silence!
    class << self
      def exit_on_failure?
        true
      end
    end

    register(Sc2::Cli::New, "new", "new BOTNAME RACE", "Creates botname folder with bot template")
    register(Sc2::Cli::Ladderzip, "ladderzip", "ladderzip BOTNAME", "Prepares a zip via docker for supplied aiarena bot name")

    # TODO: Use thor's #ask and other methods helpers of raw $stdin and puts.
    desc "setup410", "Downloads and install SC2 v4.10"
    # downloads and install SC2 v4.10
    def setup410
      puts " "
      puts "This script sets up SC2 at version 4.10, which we use competitively."
      puts "Press any key to continue..."
      puts " "
      $stdin.getch

      puts "You must accept the Blizzard® Starcraft® II AI and Machine Learning License at"
      puts "https://blzdistsc2-a.akamaihd.net/AI_AND_MACHINE_LEARNING_LICENSE.html"
      puts "It is PERMISSIVE and grants you freedoms over the standard EULA."
      puts "We do not record this action, but depend on software goverend by that license to continue."
      puts 'If you accept, type "iagreetotheeula" (without quotes) and press ENTER to continue:'

      while $stdin.gets.chomp != "iagreetotheeula"
        puts ""
        puts 'Type "iagreetotheeula" (without quotes) and press ENTER to continue:'
      end
      puts ""
      puts ""
      puts "Great decision."

      Async do
        Sc2.logger.level = :fatal
        puts "SC2 will launch a blank window, be unresponsive, but download about 100mb in the background."
        puts "Let it finish and close itself."
        puts "Press ENTER if you understand."
        $stdin.getch

        puts ""
        puts ""
        puts "This will only take a minute..."

        Sc2.config.version = nil
        client = Sc2::ClientManager.obtain(0)
        if Gem.win_platform?
          sleep(10)
        end
        observer = Sc2::Player::Observer.new
        observer.connect(host: client.host, port: client.port)
        setup_replay = Sc2::Paths.gem_root.join("data", "setup", "setup.SC2Replay")
        observer.api.replay_info(
          replay_data: File.binread(setup_replay),
          download_data: true
        )

        # Auto-detect executable path and ensure it matched exactly
        base_build = "75689"
        path = Sc2::Paths.executable(base_build: base_build)
        if path.include?(base_build) && Pathname(path).exist?
          puts " "
          puts "Success. Downloaded complete."
          puts " "
        else
          puts "Error. Slightly worrying, but no fear."
          puts "To manually setup, grab the latest ladder maps and add them to your map folder."
          puts "Grab the latest maps from https://aiarena.net/wiki/maps/"
          puts "Detected map folder: #{Sc2::Paths.maps_dir}"
          puts "Then, download any recent replay from https://aiarena.net/ and double click to launch"
        end

        observer.disconnect
        puts "Generating sc2ai.yml to always use 4.10..."
        Sc2.config.config_file.write({"version" => "4.10"}.to_yaml.to_s)
        puts ""
        puts "Done. You're good to go."
      ensure
        Sc2::ClientManager.stop(0)
      end
    end

    desc "ladderconfig", "Prints out how you're configured for the ladder."
    def ladderconfig
      require "sc2ai"
      unless Pathname("./boot.rb").exist?
        raise Sc2::Error, "boot.rb not found. Bot started from wrong directory."
      end

      require "./boot"
      # Debug
      Sc2.logger.info "Bot class: #{$bot.class}"
      Sc2.logger.info "Config:"
      Sc2.logger.info "  in-game name: #{$bot.name}"
      Sc2.logger.info "  race: #{Api::Race.lookup($bot.race)}"
      Sc2.logger.info "  realtime: #{$bot.realtime}"
      Sc2.logger.info "  step_count: #{$bot.step_count}"
      Sc2.logger.info "  enable_feature_layer: #{$bot.enable_feature_layer}"
      Sc2.logger.info "  interface_options: #{$bot.interface_options}"
    end

    # desc "ladderzip", "Uses docker to cross-compile a compatible binary for the ladder"
    # def ladderzip
    # end

    # desc "ladderquickzip", "Ladder zip, if you have no additional gems installed."
    # long_desc <<-LONGDESC
    #   `sc2ai ladderzip_basic` will download a portable ruby and gems, then copy your bot files into a zip file.
    #
    #   If you have added any gems which need compiling, this option is not for you.
    #   Any gems built with native extensions will likely not be targeting the linux platform and be nonfunctional.
    #
    #   For a cross-platform build, use ladderzip instead. This will launch a Docker container to compile a zip for you.
    # LONGDESC
    # def ladderquickzip
    #   raise Sc2::Error, "Not yet implemented."
    # end

    desc "laddermatch", "Joins a ladder match as per aiarena spec"
    option :GamePort, required: true, desc: "SC2 port. Corresponds to SC2 launch option '-port'"
    option :LadderServer, required: true, desc: "SC2 server ip or hostname"
    option :StartPort, required: true, desc: "Match port range calculated starting at this port."
    option :OpponentId, desc: "Unique identifier"
    option :RealTime, type: :boolean, default: false, desc: "Forces realtime flag"
    def laddermatch
      require "sc2ai"

      unless Sc2.ladder?
        raise Sc2::Error, "This command is only for competing on aiarena.net"
      end

      unless Pathname("./boot.rb").exist?
        raise Sc2::Error, "boot.rb not found. Bot started from wrong directory."
      end

      Sc2.logger.level = :info

      require "./boot"

      # Ladder specific overrides
      $bot.realtime = true if options[:RealTime]
      $bot.opponent_id = options[:OpponentId] if options[:OpponentId]

      Async do
        $bot.connect(host: options[:LadderServer], port: options[:GamePort])
        $bot.join_game(
          server_host: options[:LadderServer],
          port_config: Sc2::Ports.port_config_basic(start_port: options[:StartPort], num_players: 2)
        )
        $bot.add_listener($bot, klass: Sc2::Connection::StatusListener)
        $bot.play
      end.wait
    end

    # desc "install APP_NAME", "install one of the available apps"   # [4]
    # method_options :force => :boolean, :alias => :string           # [5]
    # def install(name)
    #   user_alias = options[:alias]
    #   if options.force?
    #     # do something
    #   end
    #   # other code
    # end
  end
  # standard:enable Style/GlobalVars
end
