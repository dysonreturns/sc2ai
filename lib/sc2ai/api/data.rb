# frozen_string_literal: true

require_relative "ability_id"
require_relative "unit_type_id"
require_relative "upgrade_id"
require_relative "buff_id"
require_relative "effect_id"
require_relative "tech_tree"

module Sc2
  # Holds game data from tech tree and Api::ResponseData
  # Called once on game start
  class Data
    # @!attribute abilities
    #   @return [Hash<Integer, Api::AbilityData>]  AbilityId => AbilityData
    attr_accessor :abilities
    # @!attribute units
    #   @return [Hash<Integer, Api::UnitTypeData>] UnitId => UnitData
    attr_accessor :units
    # @!attribute upgrades
    #   @return [Hash<Integer, Api::UnitTypeData>] UnitTypeId => UnitTypeData
    attr_accessor :upgrades
    # @!attribute buffs
    # Not particularly useful data. Just use BuffId directly
    #   @return [Hash<Integer, Api::BuffData>] BuffId => BuffData
    attr_accessor :buffs
    # @!attribute effects
    # Not particularly useful data. Just use EffectId directly
    #   @return [Hash<Integer, Api::EffectData>] EffectId => EffectData
    attr_accessor :effects

    # @param data [Api::ResponseData]
    def initialize(data)
      return unless data

      @abilities = abilities_from_proto(data.abilities)
      @units = units_from_proto(data.units)
      @upgrades = upgrades_from_proto(data.upgrades)
      @buffs = buffs_from_proto(data.buffs)
      @effects = effects_from_proto(data.effects)
    end

    private

    # Indexes ability data by ability id
    # @param abilities [Array<Api::AbilityData>]
    # @return [Hash<Integer, Api::AbilityData] indexed data
    def abilities_from_proto(abilities)
      result = {}

      ability_ids = Api::AbilityId.constants.map { |c| Api::AbilityId.const_get(c) }
      abilities.each do |a|
        next if a.ability_id.zero?
        next if ability_ids.delete(a.ability_id).nil?

        result[a.ability_id] = a
      end
      result
    end

    # Indexes unit data by id
    # @param units [Array<Api::UnitTypeData>]
    # @return [Hash<Integer, Api::UnitTypeData] indexed data
    def units_from_proto(units)
      result = {}
      units.each do |u|
        next unless u.available

        result[u.unit_id] = u
      end
      result
    end

    # Indexes upgrades data by id
    # @param upgrades [Array<Api::UpgradeData>]
    # @return [Hash<Integer, Api::UpgradeData] indexed data
    def upgrades_from_proto(upgrades)
      result = {}
      upgrades.each do |u|
        result[u.upgrade_id] = u
      end
      result
    end

    def effects_from_proto(effects)
      result = {}
      effects.each do |e|
        result[e.effect_id] = e
      end
      result
    end

    def buffs_from_proto(buffs)
      result = {}
      buffs.each do |b|
        result[b.buff_id] = b
      end
      result
    end
  end
end
