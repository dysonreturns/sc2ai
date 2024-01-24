require_relative "tech_tree_data"


module Api
  # Provides helper functions which work with and rely on auto generated data in tech_tree_data.rb
  # To lighten code generation, these methods live in a file of their own and may be modified.
  module TechTree
    class << self
      # Get units can be created at source + the ability to trigger it. Optionally target a specific unit from source
      # @example
      #  # The data we reference looks like this, unit_type_creation_abilities_data
      #  UnitTypeId.FACTORY: {
      #   UnitTypeId.CYCLONE: {
      #     'ability': AbilityId.TRAIN_CYCLONE,
      #     'requires_techlab': True
      #   },
      #   UnitTypeId.HELLION: {
      #     'ability': AbilityId.FACTORYTRAIN_HELLION
      #   },
      #
      #  Targeting only a source, i.e. factory, your results are all units
      #  {
      #   UnitTypeId.CYCLONE: {
      #     'ability': AbilityId.TRAIN_CYCLONE,
      #     'requires_techlab': True
      #   },
      #   UnitTypeId.HELLION: {
      #     'ability': AbilityId.FACTORYTRAIN_HELLION
      #   },...
      #  }
      #
      #  To get the requirements, you could call a source and target like such
      #  Api::TechTree.unit_type_creation_abilities(source: ..., target: ... )
      #  {
      #    "ability" => 123
      #    "requires_techlab" => true
      #    "required_building" => 456
      #  }
      # @param source [Integer] Api::UnitTypeId the unit type which will do the creation
      # @param target [Integer] (optional) Api::UnitTypeId the unit type which will be created
      # @return [Hash] either a hash of [UnitTypeId] => { ability hash } or { ability hash } when target is present
      def unit_type_creation_abilities(source:, target: nil)
        creates_unit_types = unit_type_creation_abilities_data[source]
        unless target.nil?
          return creates_unit_types[target]
        end
        creates_unit_types
      end

      # Which ability id creates the target, given the source unit/building
      # @see Api::TechTree#unit_type_creation_abilities to get a full list of units and their creation abilities
      # @param source [Integer] Api::UnitTypeId the unit type which will do the creation
      # @param target [Integer] (optional) Api::UnitTypeId the unit type which will be created
      # @return [Integer, nil] AbilityId or nil if target is not found at source
      def unit_type_creation_ability_id(source:, target:)
        ability_hash = unit_type_creation_abilities(source: source, target: target)
        return ability_hash[:ability] if ability_hash && ability_hash[:ability]
        nil
      end

      # Returns what unit types a specific unit type can produce
      # @param unit_type_id [Integer] the unit which you want to check
      # @return [Array<Integer>] returns an array of unit type ids as per Api:UnitTypeId
      def creates_unit_types(unit_type_id:)
        unit_type_creation_abilities_data[unit_type_id].keys
      end

      # Returns what the unit type another is created from
      # @param unit_type_id [Integer] the unit which you want to check
      # @return [Array<Integer>] returns an array of unit type ids as per Api:UnitTypeId
      def unit_created_from(unit_type_id:)
        unit_created_from_data[unit_type_id]
      end

      # Returns what the unit type an upgrade is researched from
      # @param upgrade_id [Integer] the unit which you want to check
      # @return [Integer] unit_type_id an array of unit type ids as per Api:UnitTypeId
      def upgrade_researched_from(upgrade_id:)
        upgrade_researched_from_data[upgrade_id]
      end
    end
  end
end
