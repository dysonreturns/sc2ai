module Sc2
  # Command line utilities
  class Cli < Thor
    class New < Thor::Group
      include Thor::Actions
      desc "Creates a new bot"

      # Define arguments and options
      argument :botname, required: true, desc: "Bot name as on aiarena. Used as a file name (short, alpha-num, no spaces!)"
      argument :race, required: true, desc: "Choose a race", enum: %w[Terran Zerg Protoss Random]

      def self.source_root
        Paths.template_root.to_s
      end

      def checkname
        race_arg = Sc2::Cli::New.arguments.find { |a| a.name == "race" }
        unless race_arg.enum.include?(race)
          raise Thor::MalformattedArgumentError, "Invalid race #{race}, must be one of #{race_arg.enum}"
        end

        say "We need to create a filename and classname from botname '#{@botname}'"
        say "You rename classes and organize files in any way, as long as you generate a valid $bot in boot.rb"

        @botname = botname.gsub(/[^0-9a-z]/i, "")
        @directory = @botname.downcase
        @classname = botname.split(/[^0-9a-z]/i).collect { |s| s.sub(/^./, &:upcase) }.join
        @bot_file = @classname.split(/(?=[A-Z])/).join("_").downcase.concat(".rb")
        say "Race: #{race}"
        say "Class name: #{@classname}"
        say "Create directory: ./#{@directory}"
        say "Bot file: ./#{@directory}/#{@bot_file}"

        unless ask("Does this look ok?", limited_to: ["y", "n"], default: "y") == "y"
          raise SystemExit
        end
      end

      def create_target
        if Pathname("./#{@directory}").exist?
          say "Folder already exists. Refusing to overwrite.", :red
          raise SystemExit
        end

        empty_directory "./#{@directory}"
        self.destination_root = Pathname("./#{@directory}").to_s
      end

      def create_boot
        template("new/boot.rb", "boot.rb")
      end

      def create_example_match
        template("new/run_example_match.rb", "run_example_match.rb")
      end

      def create_gemfile
        template("new/Gemfile", "Gemfile")
      end

      def create_botfile
        template("new/my_bot.rb", @bot_file)
      end

      def create_ignorefile
        template("new/.ladderignore", ".ladderignore")
      end

      def copy_api
        directory("new/api", "api")
      end

      def bye
        say ""
        say "Bot generated, next steps:"
        say ""
        say "cd #{@directory} && bundle install", :green
        say ""
        say "Once your project is ready, if you haven't done so, setup SC2 v4.10 with:"
        say ""
        say "bundle exec sc2ai setup410", :green
        say ""
      end
    end
  end
end
