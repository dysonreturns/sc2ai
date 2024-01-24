require "thor"

module Sc2
  # Command line utilities
  class Cli < Thor
    package_name "Cli"
    map "-setup410" => :setup410

    desc "setup410", "downloads and install SC2 v4.10"
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
        Sc2.logger.level = Logger::FATAL
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
end
