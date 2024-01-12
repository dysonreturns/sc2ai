# frozen_string_literal: true

require "sc2ai/unit_group"

module Sc2
  # A set of action related tasks for unit groups
  class UnitGroup
    # Our first unit's bot object.
    # Returns nil if units are empty, so use safetly operator bot&.method(...)
    # @return [Sc2::Player, nil] player with active connection
    def bot
      first&.bot
    end

    # Performs action on all units in this group
    # @param ability_id [Integer]
    # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
    # @param queue_command [Boolean] shift+command
    # @return [void]
    def action(ability_id:, target: nil, queue_command: false)
      return if size.zero?

      # We're simply not letting unit groups be bot aware if units already are.
      # Grab the first unit's bot to perform actions, if necessary
      bot&.action(units: self, ability_id:, target:, queue_command:)
    end

    # Builds target unit type, i.e. issuing a build command to worker.build(...Api::UnitTypeId::BARRACKS)
    # @param unit_type_id [Integer] Api::UnitTypeId the unit type which will do the creation
    # @param target [Api::Point2D, Integer, nil] is a unit tag or a Api::Point2D. Nil for addons/orbital
    # @param queue_command [Boolean] shift+command
    def build(unit_type_id:, target: nil, queue_command: false)
      return if size.zero?

      bot&.build(units: self, unit_type_id:, target:, queue_command:)
    end

    # This structure creates a unit, i.e. this Barracks trains a Marine
    # @see #build
    alias_method :train, :build

    # Warps in unit type at target (location or pylon)
    # Will only have affect is this group consists of warp gates, i.e. bot.structures.warpgates
    # @param unit_type_id [Integer] Api::UnitTypeId the unit type which will do the creation
    # @param target [Api::Point2D] a point, which should be inside an energy source
    # @param queue_command [Boolean] shift+command
    def warp(unit_type_id:, target: nil, queue_command: false)
      return if size.zero?
      bot&.warp(units: self, unit_type_id:, target: target, queue_command:)
    end

    # Shorthand for performing action SMART (right-click)
    # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
    # @param queue_command [Boolean] shift+command
    def smart(target: nil, queue_command: false)
      action(ability_id: Api::AbilityId::SMART, target:, queue_command:)
    end

    # Shorthand for performing action ATTACK
    # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
    # @param queue_command [Boolean] shift+command
    def attack(target:, queue_command: false)
      action(ability_id: Api::AbilityId::ATTACK, target: target, queue_command: queue_command)
    end

    # Issues repair command on target
    # @param target [Api::Unit, Integer] is a unit or unit tag
    def repair(target:, queue_command: false)
      action(ability_id: Api::AbilityId::EFFECT_REPAIR, target:, queue_command:)
    end

    # Geometric/Map/Micro ---
  end
end
