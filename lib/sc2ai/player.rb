# frozen_string_literal: true

require_relative "connection/connection_listener"
require_relative "connection/status_listener"
require_relative "player/game_state"
require_relative "player/units"
require_relative "player/previous_state"
require_relative "player/geometry"
require_relative "player/actions"
require_relative "player/debug"
require "numo/narray"

module Sc2
  # Allows defining Ai, Bot, BotProcess (external), Human or Observer for a Match
  class Player
    include GameState
    # include Sc2::Connection::ConnectionListener

    extend Forwardable
    def_delegators :@api, :add_listener

    # Known races for detecting race on Api::Race::Random or nil
    # @!attribute IDENTIFIED_RACES
    #   @return [Array<Integer>]
    IDENTIFIED_RACES = [Api::Race::Protoss, Api::Race::Terran, Api::Race::Zerg].freeze

    # @!attribute api
    #   Manages connection to client and performs Requests
    #   @see Sc2::Connection and Sc2::Connection::Requests specifically
    #   @return [Sc2::Connection]
    attr_accessor :api

    # @!attribute realtime
    #   Realtime mode does not require stepping. When you observe the current step is returned.
    #   @return [Boolean] whether realtime is enabled (otherwise step-mode)
    attr_accessor :realtime

    # @!attribute step_count
    #   @return [Integer] number of frames to step in step-mode, default 1
    attr_accessor :step_count

    # @return [Api::Race::NoRace] if Observer
    # @return [Api::Race::Terran] if is_a? Bot, Human, BotProcess
    # @return [Api::Race::Zerg] if is_a? Bot, Human, BotProcess
    # @return [Api::Race::Protoss] if is_a? Bot, Human, BotProcess
    # @return [Api::Race::Random] if specified random and in-game race hasn't been scouted yet
    # @return [nil] if is_a? forgetful person
    attr_accessor :race

    # @return [String] in-game name
    attr_accessor :name

    # @return [Api::PlayerType::Participant, Api::PlayerType::Computer, Api::PlayerType::Observer] PlayerType
    attr_accessor :type

    # if @type is Api::PlayerType::Computer, set one of Api::Difficulty scale 1 to 10
    # @see Api::Difficulty for options
    # @return [Api::Difficulty::VeryEasy] if easiest, int 1
    # @return [Api::Difficulty::CheatInsane] if toughest, int 10
    attr_accessor :difficulty

    # @see Api::AIBuild proto for options
    attr_accessor :ai_build

    # @param race [Integer] see {Api::Race}
    # @param name [String]
    # @param type [Integer] see {Api::PlayerType}
    # @param difficulty [Integer] see {Api::Difficulty}
    # @param ai_build [Integer] see {Api::AIBuild}
    def initialize(race:, name:, type: nil, difficulty: nil, ai_build: nil)
      # Be forgiving to symbols
      race = Api::Race.resolve(race) if race.is_a?(Symbol)
      type = Api::PlayerType.resolve(type) if type.is_a?(Symbol)
      difficulty = Api::Difficulty.resolve(difficulty) if difficulty.is_a?(Symbol)
      ai_build = Api::AIBuild.resolve(ai_build) if ai_build.is_a?(Symbol)
      # Yet strict on required fields
      raise ArgumentError, "unknown race: '#{race}'" if race.nil? || Api::Race.lookup(race).nil?
      raise ArgumentError, "unknown type: '#{type}'" if type.nil? || Api::PlayerType.lookup(type).nil?

      @race = race
      @name = name
      @type = type
      @difficulty = difficulty
      @ai_build = ai_build
      @realtime = false
      @step_count = 1
    end

    # Connection --------------------

    # @!group Connection

    # Returns whether or not the player requires a sc2 instance
    # @return [Boolean] Sc2 client needed or not
    def requires_client?
      true
    end

    # Creates a new connection to Sc2 client
    # @param host [String]
    # @param port [Integer]
    # @see Sc2::Connection#initialize
    # @return [Sc2::Connection]
    def connect(host:, port:)
      @api&.close
      @api = Sc2::Connection.new(host:, port:)
      # @api.add_listener(self, klass: Connection::ConnectionListener)
      @api.add_listener(self, klass: Connection::StatusListener)
      @api.connect
      @api
    end

    # Terminates connection to Sc2 client
    # @return [void]
    def disconnect
      @api&.close
    end

    # @!endgroup Connection

    # API --------------------

    # @!group Api

    # @param map [Sc2::MapFile]
    # @param players [Array<Sc2::Player>]
    # @param realtime [Boolean] whether realtime mode (no manual Steps)
    def create_game(map:, players:, realtime: false)
      Sc2.logger.debug { "Creating game..." }
      @api.create_game(map:, players:, realtime:)
    end

    # @param server_host [String] ip address
    # @param port_config [Sc2::PortConfig]
    # @param interface_options [Hash]
    def join_game(server_host:, port_config:, interface_options: {})
      Sc2.logger.debug { "Player \"#{@name}\" joining game..." }
      @api.join_game(name: @name, race: @race, server_host:, port_config:, interface_options:) # , enable_feature_layer: false)
    end

    def leave_game
      @api.leave_game
    end

    # @!endgroup Api

    # PLAYERS --------------------
    # @private
    # Bot
    # race != None
    # name=''
    # type: Api::PlayerType::Participant

    # An object which interacts with an SC2 client and is game-aware.
    class Bot < Player
      include Units
      include Actions
      include Debug # unless IS_LADDER?

      # @!attribute enemy
      #   @return [Sc2::Player::Enemy]
      attr_accessor :enemy

      # @!attribute previous
      #   @return [Sc2::Player::PreviousState] the previous state of the game
      attr_accessor :previous

      # @!attribute geo
      #   @return [Sc2::Player::Geometry] geo and map helper functions
      attr_accessor :geo

      def initialize(race:, name:)
        super(race:, name:, type: Api::PlayerType::Participant, difficulty: nil, ai_build: nil)
        @previous = Sc2::Player::PreviousState.new
        @geo = Sc2::Player::Geometry.new(self)
      end

      # TODO: If this suffices for Bot and Observer, they should share this code.
      # Initializes and refreshes game data and runs the game loop
      # @return [Api::Result::Victory, Api::Result::Defeat, Api::Result::Tie, Api::Result::Undecided] result
      def play
        # Step 0
        prepare_start
        refresh_state
        started

        # Callback before first step is taken
        on_start
        # Callback for step 0
        on_step

        # Step 1 to n
        loop do
          r = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
          perform_actions
          perform_debug_commands # TODO: Detect IS_LADDER? -> unless IS_LADDER?
          step_forward
          puts (::Process.clock_gettime(::Process::CLOCK_MONOTONIC) - r) * 1000
          return @result unless @result.nil?
          break if @status != :in_game
        end
      end

      # Override to perform steps before first on_step gets called.
      # Current game_loop is 0 and @api is available
      def on_start
        # Sc2.logger.debug { "#{self.class} on_start" }
      end

      # Override to implement your own game logic.
      # Gets called whenever the game moves forward.
      def on_step
        return unless is_a? Bot

        raise NotImplementedError,
          "You are required to override #{__method__} in your Bot with: def #{__method__}"

        # Sc2.logger.debug { "#{self.class}.#{__method__}" }
        # Sc2.logger.debug "on_step"
      end

      # Callbacks ---

      # Override to handle game result (:Victory/:Loss/:Tie)
      # Called when game has ended with a result, i.e. result = ::Victory
      # @param result [Symbol] Api::Result::Victory or Api::Result::Victory::Defeat or Api::Result::Victory::Undecided
      # @example
      #   def on_finish(result)
      #     if result == :Victory
      #       puts "Yay!"
      #     else
      #       puts "Lets try again!"
      #     end
      #   end
      def on_finish(result)
        # Sc2.logger.debug { "#{self.class} on_finish" }
      end

      # Called when Random race is first detected.
      # Override to handle race identification of random enemy.
      # @param race [Integer] Api::Race::* excl *::Random
      def on_random_race_detected(race)
      end

      # Called on step if errors are present. Equivalent of UI red text errors.
      # Override to read action errors.
      # @param errors [Array<Api::ActionError>]
      def on_action_errors(errors)
        # Sc2.logger.debug errors
      end

      # Actions this player performed since the last Observation.
      # Override to read actions successfully performed
      # @param actions [Array<Api::Action>] a list of actions which were performed
      def on_actions_performed(actions)
        # Sc2.logger.debug actions
      end

      # Callback when observation.alerts is populated
      # @see enum Alert in sc2api.proto for options
      # Override to use alerts or read Player.observation.alerts
      # @example
      #   alerts.each do |alert|
      #     case alert
      #     when :NuclearLaunchDetected
      #       pp "TAKE COVER!"
      #     when :NydusWormDetected
      #       pp "FIND THE WORM!"
      #     end
      #   end
      # @param alerts [Array<Integer>] array of Api::Alert::*
      def on_alerts(alerts)
      end

      # Callback when upgrades are completed, multiple might finish on the same observation.
      # @param upgrade_ids [Array<Integer>] Api::UpgradeId::*
      def on_upgrades_completed(upgrade_ids)
      end

      # @private
      # Callback when effects occur. i.e. Scan, Storm, Corrosive Bile, Lurker Spike, etc.
      # @see Api::EffectId
      # @param effects [Array<Integer>] Api::EffectId::*
      # def on_effects(effects); end

      # Callback, on observation parse when iterating over every unit
      # Can be useful for decorating additional properties on a unit before on_step
      # A Sc2::Player should override this to decorate additional properties
      def on_parse_observation_unit(unit)
      end

      # Callback for unit destroyed. Tags might be found in `previous.all_units`
      # This excludes unknown objects, like projectiles and only shows things the API has "seen" as a unit
      # Override to use in your bot class or use Player.event_units_destroyed
      # @param unit [Api::Unit]
      # @see Sc2::Player::Units#units_destroyed
      def on_unit_destroyed(unit)
      end

      # Callback for unit created.
      # Override to use in your bot class.
      # @param unit [Api::Unit]
      def on_unit_created(unit)
      end

      # Callback for unit type changing.
      # To detect certain unit creations, you should use this method to watch morphs.
      # Override to use in your bot class or use Player.event_structures_started
      # @param unit [Api::Unit]
      # @param previous_unit_type_id [Integer] Api::UnitTypeId::*
      def on_unit_type_changed(unit, previous_unit_type_id)
      end

      # Callback for structure building began
      # Override to use in your bot class.
      # @param unit [Api::Unit]
      def on_structure_started(unit)
      end

      # Callback for structure building is completed
      # Override to use in your bot class or use Player.event_structures_completed
      # @param unit [Api::Unit]
      def on_structure_completed(unit)
      end

      # Callback for unit (Unit/Structure) taking damage
      # Override to use in your bot class or use Player.event_units_damaged
      # @param unit [Api::Unit]
      # @param amount [Integer] of damage
      def on_unit_damaged(unit, amount)
      end

      # TODO: On enemy unit entered vision. enemy units+structures.tags - previous.units+structures.tags
      # def on_enemy_enters_vision(unit)
      # end

      # TODO: On enemy unit left vision. Potentially subtract units killed to prevent interference
      # def on_enemy_exits_vision(unit)
      # end

      private

      # Writes the current observation as json to data/debug_observation.json
      # Slows step to a crawl, so don't leave this on in the ladder.
      def debug_json_observation
        File.write("#{Paths.bot_data_dir}/debug_observation.json", observation.to_json)
      end
    end

    # A specialized type of player instance which each player has one of
    # This should never be initialized by hand
    class Enemy < Player
      include Units

      # Initializes your enemy form proto
      class << self
        # Creates an Enemy object after game has started using Api::GameInfo's Api::PlayerInfo
        # @param player_info [Api::PlayerInfo]
        # @return [Sc2::Player::Enemy] your opposing player
        def from_proto(player_info: nil)
          Sc2::Player::Enemy.new(race: player_info.race_requested,
            name: player_info.player_name,
            type: player_info.type,
            difficulty: player_info.difficulty,
            ai_build: player_info.ai_build)
        end
      end

      # Will attempt to loop over player units and set its race if it can detect.
      # Generally only used for enemy
      # @return [false,Integer] Api::Race if race detected, false otherwise
      def detect_race_from_units
        return false unless race_unknown?
        return false if units.nil?
        unit_race = Api::Race.resolve(units.first.unit_data.race)
        if Sc2::Player::IDENTIFIED_RACES.include?(unit_race)
          self.race = unit_race
        end
      end
    end

    # @todo
    # TODO: Figure out a nice way to launch with community options or provide launch string:
    # +path: Union[str, Path],
    # +launch_list: List[str],
    # +sc2port_arg="--GamePort",
    # +host_address_arg="--LadderServer",
    # +match_arg="--StartPort",
    # +realtime_arg="--RealTime",
    # +other_args: str = None,
    # +stdout: str = None,

    # @private
    # Launches an external bot, such as a python practice partner by triggering an exteral executable.
    # Allows using CLI launch options hash or "laddorconfig.json"-complient launcher.
    class BotProcess < Player
      def initialize(race:, name:)
        super(race:, name:, type: Api::PlayerType::Participant)
        raise "not implemented"
      end
    end

    # A Computer opponent using the game's built-in AI for a Match
    class Computer < Player
      # @param race [Integer] (see Api::Race)
      # @param difficulty [Integer] see Api::Difficulty::VeryEasy,Api::Difficulty::VeryHard,etc.)
      # @param ai_build [Api::AIBuild::RandomBuild] (see Api::AIBuild)
      # @param name [String]
      # @return [Sc2::Computer]
      def initialize(race:, difficulty: Api::Difficulty::VeryEasy, ai_build: Api::AIBuild::RandomBuild,
        name: "Computer")
        difficulty = Api::Difficulty::VeryEasy if difficulty.nil?
        ai_build = Api::AIBuild::RandomBuild if ai_build.nil?
        raise Error, "unknown difficulty: '#{difficulty}'" if Api::Difficulty.lookup(difficulty).nil?
        raise Error, "unknown difficulty: '#{ai_build}'" if Api::AIBuild.lookup(ai_build).nil?

        super(race:, name:, type: Api::PlayerType::Computer, difficulty:, ai_build:)
      end

      # Returns whether or not the player requires a sc2 instance
      # @return [Boolean] false always for Player::Computer
      def requires_client?
        false
      end

      # @private
      def connect(host:, port:)
        raise Error, "Computer type can not connect to api"
      end
    end

    # A human player for a Match
    class Human < Player
      def initialize(race:, name:)
        super(race:, name:, type: Api::PlayerType::Participant)
      end
    end

    # A spectator for a Match
    class Observer < Player
      def initialize(name: nil)
        super(race: Api::Race::NoRace, name:, type: Api::PlayerType::Observer)
      end
    end

    # Data Parsing ------------------------

    # Checks whether the Player#race is known. This is false on start for Random until scouted.
    # @return [Boolean] true if the race is Terran, Protoss or Zerg, or false unknown
    def race_unknown?
      !IDENTIFIED_RACES.include?(race)
    end

    private

    # Initialize data on step 0 before stepping and before on_start is called
    def prepare_start
      @data = Sc2::Data.new(@api.data)
      clear_action_queue
      clear_debug_command_queue
    end

    # Initialize step 0 after data has been gathered
    def started
      # Calculate expansions
      geo.expansions
    end

    # Moves emulation ahead and calls back #on_step
    # @return [Api::Observation] observation of the game state
    def step_forward
      # Sc2.logger.debug "#{self.class} step_forward"

      unless @realtime
        # ##TODO: Numsteps as config
        num_steps = 1
        @api.step(num_steps)
      end

      refresh_state
      on_step if @result.nil?
    end

    # Refreshes game state for current loop.
    # Will update GameState#observation and GameState#game_info
    # @return [void]
    # TODO: After cleaning up all the comments, review whether this is too heavy or not. #perf #clean
    def refresh_state
      # Process.clock_gettime(Process::CLOCK_MONOTONIC)
      step_to_loop = @realtime ? game_loop + @step_count : nil
      response_observation = @api.observation(game_loop: step_to_loop)

      # Check if match has a result and callback
      on_player_result(response_observation.player_result) unless response_observation.player_result.empty?
      # Halt further processing if match is over
      return unless @result.nil?

      # Save previous frame before continuing
      @previous.reset(self)
      # Reset
      self.observation = response_observation.observation
      self.chats_received = response_observation.chat
      self.spent_minerals = 0
      self.spent_vespene = 0
      self.spent_supply = 0
      # Geometric/map
      if observation.raw_data.map_state.visibility != previous.observation&.raw_data&.map_state&.visibility
        @parsed_visibility_grid = nil
      end

      # Only grab game_info if unset (loop 0 or first realtime loop). It's lazily loaded otherwise as needed
      # This is heavy processing, because it contains image data
      if game_info.nil?
        refresh_game_info
        set_enemy
        set_race_for_random if race == Api::Race::Random
      end

      parse_observation_units(response_observation.observation)

      # Having loaded all the necessities for the current state...
      # If we're on the first frame of the game, say previous state and current are the same
      # This is better than having a bunch of random zero and nil values
      @previous.reset(self) if game_loop.zero?

      # TODO: remove @events attributes if we don't use them for performance gains
      # Actions performed and errors (only if implemented)
      on_actions_performed(response_observation.actions) unless response_observation.actions.empty?
      on_action_errors(response_observation.action_errors) unless response_observation.action_errors.empty?
      on_alerts(observation.alerts) unless observation.alerts.empty?

      # Diff previous observation upgrades to see if anything new completed
      new_upgrades = observation.raw_data.player.upgrade_ids - @previous.observation.raw_data.player.upgrade_ids
      on_upgrades_completed(new_upgrades) unless new_upgrades.empty?

      # Dead units
      raw_dead_unit_tags = observation.raw_data&.event&.dead_units
      @event_units_destroyed = UnitGroup.new
      raw_dead_unit_tags&.each do |dog_tag|
        dead_unit = previous.all_units[dog_tag]
        unless dead_unit.nil?
          @event_units_destroyed.add(dead_unit)
          on_unit_destroyed(dead_unit)
        end
      end

      # If enemy is not known, try detect every couple of frames based on units
      if enemy.race_unknown? && enemy.units.size > 0
        detected_race = enemy.detect_race_from_units
        on_random_race_detected(detected_race) if detected_race
      end
    end

    # @private
    # Refreshes bot#game_info ignoring all caches
    # @return [void]
    public def refresh_game_info
      self.game_info = @api.game_info
    end

    # Data Parsing -----------------------

    # If you're random, best to set #race to match after launched
    def set_race_for_random
      player_info = game_info.player_info.find { |pi| pi.player_id == observation.player_common.player_id }
      self.race = player_info.race_actual
    end

    # Sets enemy once #game_info becomes available on start
    def set_enemy
      enemy_player_info = game_info.player_info.find { |pi| pi.player_id != observation.player_common.player_id }
      self.enemy = Sc2::Player::Enemy.from_proto(player_info: enemy_player_info)

      if enemy.nil?
        self.enemy = Sc2::Player::Enemy.new(name: "Unknown", race: Api::Race::Random)
      end
      if enemy.race_unknown?
        detected_race = enemy.detect_race_from_units
        on_random_race_detected(detected_race) if detected_race
      end
    end

    # Misc -------------------------------
    # ##TODO: perfect loop implementation
    # observation has an optional param game_loop and will only return once that step is reached (blocking).
    # without it, it returns things as they are.
    # broadly, i think this is what it should be doing, with step_size being minimum of 1, so no zero-steps occur.
    # @example
    # desired_game_loop = current_game_loop + step_size
    # response = client.observation(game_loop: desired_game_loop)
    #
    #   if response.game_loop > desired_game_loop {
    #
    #     # our requested point-in-time has passed. bot too slow or unlucky timing.
    #     # so, just re-query things as they stand right now:
    #     missed_response = response
    #     # note no game_loop argument supplied this time
    #     response = client.observation()
    #
    #     # Combine observations so you didn't miss anything
    #     # Merges
    #     response.actions.merge(missed_response.actions)
    #     response.action_errors.merge(missed_response.action_errors)
    #     response.chat.merge(missed_response.chat)
    #
    #     # Overrides
    #     if missed_response.player_result && response.player_result.empty?
    #       response.player_result = player_result
    #     end
    #
    #       # Note we don't touch reponse.observation and keep the latest
    #   end
    #   current_game_loop = response.game_loop
    #   return response # or dispatch events with it
    # def perfect_loop
    # end

    private

    # @private
    # Parses player result and neatly calls back to on_finish
    # If overriding this, it must manually do callback to player on_finish
    # @return [Symbol,nil] Api::Result::**
    def on_player_result(player_results)
      player_results.each do |player_result|
        if player_result.player_id == common.player_id
          @result = player_result.result
          on_finish(player_result.result)
        end
      end

      nil
    end
  end
end
