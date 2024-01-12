# frozen_string_literal: true

# RUBY_GC_MALLOC_LIMIT=128000000000;
# RUBY_GC_OLDMALLOC_LIMIT=128000000000;
# RUBY_GC_OLDMALLOC_LIMIT_MAX=128000000000;
# RUBY_GC_HEAP_INIT_SLOTS=329375

# GC tuning.
GC.disable
# TODO: MOVE RUBY_GC_* to load into shell ENV, because they apparently can't be set at runtime.
# Arbitrary very large numbers which should not be reached
# ENV['RUBY_GC_OLDMALLOC_LIMIT'] = "128000000000"
# ENV['RUBY_GC_OLDMALLOC_LIMIT_MAX'] = "128000000000"

# Preallocate slightly over observed GC stats
# Ruby 3.3
# TODO: Check if these vars can be set at runtime when moving to 3.3 or move to a runner.
# TODO: Benchmark extremely long filled map and re-adjust. These are medium sized game and can be 2-10x'd.
ENV["RUBY_GC_HEAP_INIT_SIZE_40_SLOTS"] = "170000"
ENV["RUBY_GC_HEAP_INIT_SIZE_80_SLOTS"] = "25000"
ENV["RUBY_GC_HEAP_INIT_SIZE_160_SLOTS"] = "9000"
ENV["RUBY_GC_HEAP_INIT_SIZE_320_SLOTS"] = "1000"
ENV["RUBY_GC_HEAP_INIT_SIZE_640_SLOTS"] = "500"

GC.enable
GC.start
# In the event major runs, let it compact
GC.auto_compact = true

# For Numo linear algebra, fix paths for specific macOS's
if ENV["LD_LIBRARY_PATH"].nil?
  ENV["LD_LIBRARY_PATH"] = "/opt/homebrew/opt/lapack/lib:/opt/homebrew/opt/openblas/lib"
else
  ENV["LD_LIBRARY_PATH"] += ":/opt/homebrew/opt/lapack/lib:/opt/homebrew/opt/openblas/lib"
end
begin
  require "numo/linalg/autoloader"
rescue => e
  puts "Error from numo-linalg: #{e}"
  puts "Lets get some linear algebra on your system..."
  puts 'Mac: "brew install openblas"'
  puts 'Debian/Ubuntu and WSL2: "apt install libblas3 liblapacke"'
  if Gem.win_platform?
    puts 'Windows: from CMD "ridk enable & pacman -S mingw-w64-ucrt-x86_64-openblas --noconfirm".'
  end
  puts 'That should be enough. If you still experience issues, "bundle install --redownload" to rebuild dependencies anew'
  exit
end
require "rumale"

# noinspection RubyMismatchedArgumentType
Dir.glob(File.join(__dir__, "sc2ai", "overrides", "**", "*.rb")).each do |file|
  require(file)
end

# Protobuf internals don't allow sharing enums in the same package,
#  so Blizzard under_scored some names. This throws errors when defining constants
#  during packing/unpacking, because they dont start capitalized, so we silence temporarily.
silence_warnings do
  require_relative "sc2ai/protocol/sc2api_pb"
end
# noinspection RubyMismatchedArgumentType
Dir[File.join(__dir__, "sc2ai", "*.rb")].each { |file| require(file) }
# The upper include can probably preload everything it needs
# noinspection RubyMismatchedArgumentType
Dir[File.join(__dir__, "sc2ai", "protocol", "extensions", "**", "*.rb")].each { |file| require(file) }
# noinspection RubyMismatchedArgumentType
Dir[File.join(__dir__, "sc2ai", "local_play", "**", "*.rb")].each { |file| require(file) }

# Facilitates creating and running Starcraft 2 AI instances.
module Sc2
  # Generic, single error for everything Sc2
  class Error < StandardError; end

  class << self
    # Instantiate the Configuration singleton or return it.
    # Remember that the instance has attribute readers so that we can access the configured values
    def config
      @config ||= Configuration.new
      yield @config if block_given?
      @config
    end

    # Set to new Sc2::Configuration
    attr_writer :config

    # Sets logger singleton
    attr_writer :logger

    # @return [Logger] a logger instance or a new $stdout logger if undefined
    def logger
      return @logger if @logger

      require "logger"

      @logger = Logger.new($stdout)
      @logger.level = :debug
      @logger
    end
  end
end
