module Sc2
  # Command line utilities
  class Cli < Thor
    # Populating "./build" with our source...
    # - Symlink executable ./build/bin/ladder to ./.build/botname for ladder
    # - copy our source to .build, sans .ladderignore
    # copy .build to docker
    # bundle install on docker
    # zipping up code + ruby + gems
    # get zip, clean up
    # stop docker
    # standard:disable Style/GlobalVars
    class Ladderzip < Thor::Group
      include Thor::Actions

      # Define arguments and options
      argument :botname, desc: "Your bot name as on aiarena.net. Will be used as a filename (alphanumeric, no spaces)."
      desc "Builds a ladder zip using docker (requires docker)"

      def docker_exists
        if Kernel.system("docker --version", out: File::NULL, err: File::NULL)
          say_status("docker", "found", :green)
        else
          say_status("docker", "not found", :red)
          say("Please install 'docker' and/or ensure it's in your PATH to continue.")
          raise SystemExit
        end

        if Kernel.system("docker info", out: File::NULL, err: File::NULL)
          say_status("docker engine", "found", :green)
        else
          say("  ")
          say_status("docker engine", "offline", :red)
          say("Please start docker engine. If you have Docker Desktop installed, open it before retrying.")
          raise SystemExit
        end

      end

      def set_compose_file
        @compose_file = Sc2::Paths.gem_root
          .join("lib", "docker_build", "docker-compose-ladderzip.yml")
          .expand_path.to_s
      end

      def bot_validation
        if Pathname("./boot.rb").exist?
          say_status("detected boot.rb", "found", :green)
        else
          say_status("detected boot.rb", "not found", :red)
          raise Sc2::Error, "boot.rb not found. Bot started from wrong directory."
        end

        require "./boot"

        if $bot.is_a? Sc2::Player
          say_status("instance $bot", $bot.class, :green)
        else
          say_status("instance $bot", $bot.class, :red)
          raise Sc2::Error, "$bot instance nil or not Sc2::Player. Review boot.rb to ensure it creates $bot."
        end
      end

      def self.source_paths
        [Pathname(".").expand_path.to_s]
      end

      def self.source_root
        Paths.template_root.to_s
      end

      def ensure_build_dir
        empty_directory "./.build"
      end

      def create_executable
        template("ladderzip/bin/ladder", "./.build/bin/ladder")
        # This fails on Windows. creating by hand in #link_ladder function below.
        #create_link("./.build/#{botname}", "./bin/ladder")
      end

      def start_container
        cmd = "docker compose -f #{@compose_file} up bot -d --force-recreate"
        Kernel.system(cmd)
      end

      def populate_build
        # Manually parse *ignore file. Not doing a docker build on this simply to abuse dockerignore.
        ignore_pattern = File.open("./.ladderignore").each_line
          .collect(&:strip)
          .reject { |pt| pt&.start_with?("#") || pt&.size&.zero? }
        ignore_pattern << "**.build/*"
        ignore_pattern << "**.ruby/*"

        include_pattern = ignore_pattern.select { |pt| pt&.start_with?("!") }
        ignore_pattern -= include_pattern

        include_pattern.collect! { |pt| pt.delete_prefix("!") }

        files = Dir.glob("**/*")
        ignored_files = files
          .select { |f| ignore_pattern.any? { |p| File.fnmatch?(p, f) } }
          .reject! { |f| include_pattern.any? { |p| File.fnmatch?(p, f) } }
        files -= ignored_files unless ignored_files.nil?

        files.each do |file|
          next if File.directory?(file)
          copy_file file, "./.build/#{file}"
        end
      end

      def copy_build_to_docker
        say_status("docker", "copying source...", :cyan)
        cmd = "docker compose -f #{@compose_file} cp ./.build/. bot:/root/ruby-builder/"
        Kernel.system(cmd)
      end

      def link_ladder
        say_status("docker", "linking executable...", :cyan)
        cmd = "docker compose -f #{@compose_file} exec --workdir /root/ruby-builder bot ln -s ./bin/ladder ./#{botname}"
        Kernel.system(cmd)
      end

      def install_gems
        say_status("docker", "bundle install...", :cyan)
        cmd = "docker compose -f #{@compose_file} exec --workdir /root/ruby-builder bot bundle install"
        Kernel.system(cmd)
      end

      def compress
        say_status("docker", "compress ladder zip...", :cyan)
        cmd = "docker compose -f #{@compose_file} exec --workdir /root/ruby-builder bot zip -qry9 /root/build.zip ."
        Kernel.system(cmd)
      end

      def retreive_zip
        say_status("docker", "pulling 'build.zip'", :green)
        cmd = "docker compose -f #{@compose_file} cp bot:/root/build.zip ."
        Kernel.system(cmd)
        if File.exist?("./build.zip")
          say_status("docker", "pulled 'build.zip' ok", :green)
        else
          say_status("docker", "error pulling 'build.zip'", :red)
          exit
        end
        cmd = "docker compose -f #{@compose_file} exec bot rm /root/build.zip"
        Kernel.system(cmd)
      end

      def clean
        remove_file "./.build"
      end

      def stop_container
        cmd = "docker compose --progress=plain -f #{@compose_file} stop bot"
        Kernel.system(cmd)
      end

      def bye
        say ""
        say "Your bot is ready to upload. Use the file 'build.zip'."
        say ""
        say "A friendly reminder that since you passed \"#{botname}\", "
        say "aiarena expects your bot to be named exactly that."
        say "If the names mismatch, simply rerun this command with the correct BOTNAME."
        say ""
        say "Good luck."
      end
    end
    # standard:enable Style/GlobalVars
  end
end
