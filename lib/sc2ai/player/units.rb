# frozen_string_literal: true

module Sc2
  class Player
    # Helper methods for working with units
    module Units
      # @!attribute all_units
      #   @return [Sc2::UnitGroup]
      attr_accessor :all_units

      # A full list of all your units (non-structure)
      # @!attribute units
      #   @return [Sc2::UnitGroup] a group of units
      attr_accessor :units

      # A full list of all your structures (non-units)
      # @!attribute units
      #   @return [Sc2::UnitGroup] a group of units
      attr_accessor :structures

      # All units with alliance :Neutral
      # @!attribute neutral
      #   @return [Sc2::UnitGroup] a group of neutral units
      attr_accessor :neutral

      # An array of effects such as Scan, Storm, Corrosive Bile, Lurker Spike, etc.
      # They typically have a position on the map and may be persistent or temporary.
      # Shorthand for observation.raw_data.effects
      # @!attribute effects
      #   @return [Sc2::UnitGroup] a group of neutral units
      attr_accessor :effects # not a unit

      # An array of Protoss power sources, which have a point, radius and unit tag
      # @!attribute power_sources
      #   @return [Array<Api::PowerSource>] an array of power sources
      attr_accessor :power_sources # not a unit but has a tag

      # An array of Sensor tower rings as per minimap. It has a `pos` and a `radius`
      # @!attribute power_sources
      #   @return [Array<Api::RadarRing>] an array of power sources
      attr_accessor :radar_rings # not a unit but has a tag

      # @private
      # @!attribute all_seen_unit_tags
      # Privately keep track of all seen Unit tags (excl structures) in order to detect new created units
      attr_accessor :_all_seen_unit_tags

      # Event-driven unit groups ---

      # @!attribute event_units_created
      # Units created since last frame (visible only, units not structures)
      # Read this on_step. Alternative to callback on_unit_created
      # @note Morphed units should watch #event_units_type_changed
      #   @return [Sc2::UnitGroup] group of created units
      attr_accessor :event_units_created

      # Units which had their type changed since last frame
      # Read this on_step. Alternative to callback on_unit_type_changed
      # @!attribute event_units_type_changed
      #   @return [Sc2::UnitGroup] group effected
      attr_accessor :event_units_type_changed

      # Structures seen since last frame with building not completed (< 1.0)
      # Read this on_step. Alternative to callback on_structure_started
      # @!attribute event_structures_started
      #   @return [Sc2::UnitGroup] a group of structures started
      attr_accessor :event_structures_started

      # Structures which had their building completed (==1.0) since last frame
      # Read this on_step. Alternative to callback on_structure_completed
      # @!attribute event_structures_completed
      #   @return [Sc2::UnitGroup] a group of structures started
      attr_accessor :event_structures_completed

      # Units and Structures which had their health/shields reduced since last frame
      # Read this on_step. Alternative to callback on_unit_damaged
      # @!attribute event_units_damaged
      #   @return [Sc2::UnitGroup] group of Units and Structures effected
      attr_accessor :event_units_damaged

      # Units destroyed since last frame (known units only, i.e. not projectiles)
      # Read this on_step. Alternative to callback on_unit_destroyed
      # @!attribute event_units_destroyed
      #   @return [Sc2::UnitGroup] group of dead units
      attr_accessor :event_units_destroyed

      # TODO: Unit buff disabled, because it calls back too often (mineral in hand). Put back if useful
      # @private
      # Units (Unit/Structure) on which a new buff_ids appeared this frame
      # See which buffs via: unit.buff_ids - unit.previous.buff_ids
      # Read this on_step. Alternative to callback on_unit_buffed
      # @!attribute event_units_destroyed
      # attr_accessor :event_units_buffed

      # Returns static [Api::UnitTypeData] for a unit
      # @param unit [Integer,Api::Unit] Api::UnitTypeId or Api::Unit
      # @return [Api::UnitTypeData]
      def unit_data(unit)
        id = unit.is_a?(Integer) ? unit : unit.unit_type
        data.units[id]
      end

      # Returns static [Api::AbilityData] for an ability
      # @param ability_id [Integer] Api::AbilityId::*
      # @return [Api::AbilityData]
      def ability_data(ability_id)
        data.abilities[ability_id]
      end

      # Checks unit data for an attribute value
      # @param unit [Integer,Api::Unit] Api::UnitTypeId or Api::Unit
      # @param attribute [Symbol] Api::Attribute, i.e. Api::Attribute::Mechanical or :Mechanical
      # @return [Boolean] whether unit has attribute
      # @example
      #   unit_has_attribute?(Api::UnitTypeId::SCV, Api::Attribute::Mechanical)
      #   unit_has_attribute?(units.workers.first, :Mechanical)
      #   unit_has_attribute?(Api::UnitTypeId::SCV, :Mechanical)
      def unit_has_attribute?(unit, attribute)
        unit_data(unit).attributes.include? attribute
      end

      # Creates a unit group from all_units with matching tag
      # @param tags [Array<Integer>] array of unit tags
      # @return [Sc2::UnitGroup]
      def unit_group_from_tags(tags)
        return unless tags.is_a? Array

        ug = UnitGroup.new
        tags.each do |tag|
          ug.add(@all_units[tag])
        end
        ug
      end

      # Geo/Map/Macro ------

      # @private
      # Sums the cost (mineral/vespene/supply) of unit type used for internal spend trackers
      # This is called internally when building/morphing/training
      # @return [void]
      def subtract_cost(unit_type_id)
        unit_type_data = unit_data(unit_type_id)

        # food_required is a float. ensure half units are counted as full
        # TODO: Extend UnitTypeData message. def food_required = unit_id ==  Api::UnitTypeId::ZERGLING ? 1 : send("method_missing", :food_required)
        supply_cost = unit_type_data.food_required
        supply_cost = 1 if unit_type_id == Api::UnitTypeId::ZERGLING

        @spent_minerals += unit_type_data.mineral_cost
        @spent_vespene += unit_type_data.vespene_cost
        @spent_supply += supply_cost
      end

      # Checks whether you have the resources to construct quantity of unit type
      def can_afford?(unit_type_id:, quantity: 1)
        unit_type_data = unit_data(unit_type_id)
        return false if unit_type_data.nil?

        mineral_cost = unit_type_data.mineral_cost * quantity
        if common.minerals - spent_minerals < mineral_cost
          return false # not enough minerals
        end

        vespene_cost = unit_type_data.vespene_cost * quantity
        if common.vespene - spent_vespene < vespene_cost
          return false # you require more vespene gas
        end

        supply_cost = unit_type_data.food_required
        supply_cost = 1 if unit_type_id == Api::UnitTypeId::ZERGLING
        supply_cost *= quantity

        free_supply = common.food_cap - common.food_used
        if free_supply - spent_supply < supply_cost
          return false # you must construct additional pylons
        end

        true
      end

      private

      # @private
      # Divides raw data units into various attributes on every step
      # Note, this needs to be fast.
      # @param observation [Api::Observation]
      def parse_observation_units(observation)
        @all_units = UnitGroup.new(observation.raw_data.units)
        # Clear previous units and prep for categorization
        @units = UnitGroup.new
        @structures = UnitGroup.new
        @enemy.units = UnitGroup.new
        @enemy.structures = UnitGroup.new
        @neutral = UnitGroup.new
        @effects = observation.raw_data.effects # not a unit
        @power_sources = observation.raw_data.player.power_sources # not a unit
        @radar_rings = observation.raw_data.radar
        @blips = UnitGroup.new

        # Unit tag tracking
        @_all_seen_unit_tags ||= Set.new(@units.tags)

        # Event-driven unit groups as callback alternatives
        @event_units_created = UnitGroup.new
        @event_structures_started = UnitGroup.new
        @event_structures_completed = UnitGroup.new
        @event_units_type_changed = UnitGroup.new
        @event_units_damaged = UnitGroup.new
        # @event_units_buffed = UnitGroup.new

        # Categorization of self/enemy, structure/unit ---
        own_alliance = self.own_alliance
        enemy_alliance = self.enemy_alliance

        # To prevent several loops over all units per frame, use this single loop for all checks
        all_unit_size = observation.raw_data.units.size
        i = 0
        while i < all_unit_size
          unit = observation.raw_data.units[i]
          tag = unit.tag
          tag = unit.tag = unit.hash if tag.zero?
          # Reluctantly assigning player to unit
          unit.bot = self

          # Categorize own units/structures, enemy units/structures, neutral
          if unit.is_blip
            @blips[tag] = unit
          elsif unit.alliance == own_alliance || unit.alliance == enemy_alliance
            if unit.alliance == own_alliance
              structure_collection = @structures
              unit_collection = @units
            else
              structure_collection = @enemy.structures
              unit_collection = @enemy.units
            end

            unit_data = unit_data(unit.unit_type)
            if unit_data.attributes.include? :Structure
              structure_collection[tag] = unit
            else
              unit_collection[tag] = unit
            end
          else
            @neutral[tag] = unit
          end

          # Dont parse callbacks on first loop or for neutral units
          if !game_loop.zero? &&
              unit.alliance != :Neutral &&
              unit.display_type != :Placeholder &&
              unit.is_blip == false

            previous_unit = @previous.all_units[unit.tag]

            # Unit created/changed/damage modifiers ---
            if previous_unit.nil?
              issue_new_unit_callbacks(unit)
            else
              issue_existing_unit_callbacks(unit, previous_unit)
            end
          end

          # Allow user to fiddle with unit
          on_parse_observation_unit(unit)

          i += 1
        end
      end

      # @private
      # Returns alliance based on whether you are a player or an enemy
      # @return [:Symbol] :Self or :Enemy from Api::Alliance
      def own_alliance
        if is_a? Sc2::Player::Enemy
          Api::Alliance.lookup(Api::Alliance::Enemy)
        else
          Api::Alliance.lookup(Api::Alliance::Self)
        end
      end

      # @private
      # Returns enemy alliance based on whether you are a player or an enemy
      # @return [:Symbol] :Self or :Enemy from Api::Alliance
      def enemy_alliance
        if is_a? Sc2::Player::Enemy
          Api::Alliance.lookup(Api::Alliance::Self)
        else
          Api::Alliance.lookup(Api::Alliance::Enemy)
        end
      end

      # @private
      # Issues units/structure callbacks for units which are new
      def issue_new_unit_callbacks(unit)
        return if @_all_seen_unit_tags.include?(unit.tag)

        if unit.is_structure?
          if unit.build_progress < 1
            @event_structures_started.add(unit)
            on_structure_started(unit)
          else
            @event_structures_completed.add(unit)
            on_structure_completed(unit)
          end
        else
          @event_units_created.add(unit)
          on_unit_created(unit)
        end
        @_all_seen_unit_tags.add(unit.tag)
      end

      # @private
      # Issues callbacks for units over time, such as damaged or type changed
      def issue_existing_unit_callbacks(unit, previous_unit)
        # Check if a unit type has changed
        if unit.unit_type != previous_unit.unit_type
          @event_units_type_changed.add(unit)
          on_unit_type_changed(unit, previous_unit.unit_type)
        end

        # Check if a unit type has changed
        if unit.health < previous_unit.health || unit.shield < previous_unit.shield
          damage_amount = previous_unit.health - unit.health + previous_unit.shield - unit.shield
          @event_units_damaged.add(unit)
          on_unit_damaged(unit, damage_amount)
        end

        if unit.is_structure?
          if previous_unit.build_progress < 1 && unit.build_progress == 1
            @event_structures_completed.add(unit)
            on_structure_completed(unit)
          end
        end
      end
    end
  end
end
