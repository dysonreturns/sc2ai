# frozen_string_literal: true

module Sc2
  class Player
    # Holds game state
    module GameState
      # @!attribute status
      #   @return [:launched, :in_game, :in_replay, :ended, :quit, :unknown] status
      attr_accessor :status

      include Connection::StatusListener
      # Callback when game status changes
      def on_status_change(status)
        self.status = status
      end

      extend Forwardable

      # @!attribute game_loop
      #   @return [Integer] current game loop
      def_delegators :observation, :game_loop

      # @!attribute game_info [rw]
      # Access useful game information. Used in parsed pathing grid, terrain height, placement grid.
      # Holds Api::ResponseGameInfo::#start_locations.
      # @return [Api::ResponseGameInfo]
      attr_reader :game_info

      def game_info=(new_info)
        @game_info_loop = game_loop || 0
        @game_info = new_info
      end

      # @!attribute game_info_loop
      #   This is the last loop at which game_info was set.
      #   Used to determine staleness.
      # @return [Integer]
      attr_accessor :game_info_loop

      # Determines if your game_info will be refreshed at this moment
      # Has a hard-capped refresh of only ever 2 steps
      # In general game_info is only refreshed Player::Bot reads from pathing_grid or placement_grid
      # @return [Boolean]
      def game_info_stale?
        return true if game_info_loop.nil? || game_info.nil?
        return false if game_info_loop == game_loop

        # Note: No minimum step count set anymore
        # We can do something like, only updating every 2+ frames:
        game_info_loop + 2 <= game_loop
      end

      # @!attribute data
      #   @return [Api::ResponseData]
      attr_accessor :data

      # @!attribute observation
      #   @return [Api::Observation] snapshot of current game state
      attr_writer :observation

      # @!attribute chats_received
      #   @return [Array<Api::ChatReceived>] messages since last observation
      #
      # @example
      #   # Useful for commanding your own bot on step
      #   chats_received.each do |chat|
      #     if chat.message == "!gg"
      #       if chat.player_id == common.player_id
      #         # we sent this...
      #         leave_game # ladder surrender
      #         exit # exit script
      #       else
      #         # someone else messaged, dont quit
      #       end
      #     end
      #   end
      attr_writer :chats_received

      # @!attribute result
      #   @return [Api::Result] the result of the game (:Victory/:Defeat/:Tie)
      attr_accessor :result

      # @!attribute spent_minerals
      #   @see Unit#build and #morph
      #   @return [Integer] sum of minerals spent via Unit##build an Unit#morph
      attr_accessor :spent_minerals

      # @!attribute spent_vespene
      #   @see Unit#build and #morph
      #   @return [Integer] sum of vespene gas spent via Unit##build an Unit##morph
      attr_accessor :spent_vespene

      # @!attribute spent_supply
      #   @see Unit#build and #morph
      #   @return [Integer] sum of supply spent via Unit##build an Unit##morph
      attr_accessor :spent_supply

      def observation
        @observation || Api::Observation.new(game_loop: 0)
      end

      def chats_received
        @chats_received || []
      end

      # An alias for observation.player_common to allow easier access to i.e. common.minerals
      # @return [Api::PlayerCommon] common info such as minerals, vespene, supply
      def common
        observation.player_common || Api::PlayerCommon.new(
          player_id: 0,
          minerals: 50,
          vespene: 0,
          food_cap: ((race == Api::Race::Zerg) ? 14 : 15),
          food_used: 12,
          food_army: 0,
          food_workers: 12,
          idle_worker_count: 0,
          army_count: 0,
          warp_gate_count: 0,
          larva_count: ((race == Api::Race::Zerg) ? 3 : 0)
        )
      end

      # class << self
      #   def included(_mod)
      #     @status = :unknown
      #   end
      # end
    end
  end
end
