# frozen_string_literal: true

module Sc2
  class Player
    # Container for the previous game state, based on current bot state
    # Keep to one instance, but with variables to prevent large memory leaks
    # @see Sc2::Player::GameState for current state
    class PreviousState
      include GameState
      include Units

      # Sets the previous state of the bot using the last frame
      # @param bot [Sc2::Player::Bot]
      def reset(bot)
        before_reset(bot)
        @all_units = bot.all_units
        @units = bot.units
        @structures = bot.structures
        @neutral = bot.neutral
        @effects = bot.effects
        @power_sources = bot.power_sources
        @radar_rings = bot.radar_rings

        @status = bot.status
        @game_info = bot.game_info
        @observation = bot.observation

        @spent_minerals = bot.spent_minerals
        @spent_vespene = bot.spent_vespene
        @spent_supply = bot.spent_supply
        # Skipping unnecessary bloat: events_*, chats_received, ...

        after_reset(bot)
      end

      # Override to modify the previous frame before being set to current
      # @param bot [Sc2::Player::Bot]
      def before_reset(bot)
        # pp "### before_reset"
      end

      # Override to modify previous frame after reset is complete
      # @param bot [Sc2::Player::Bot]
      def after_reset(bot)
        # pp "### after_reset"
      end
    end
  end
end
