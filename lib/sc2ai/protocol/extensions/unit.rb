# frozen_string_literal: true

module Api
  # Adds additional functionality to message object Api::Unit
  # Mostly adds convenience methods by adding direct access to the Sc2::Bot data and api
  module UnitExtension
    # @private
    def hash
      tag || super
    end

    # Every unit gets access back to the bot to allow api access.
    # For your own units, this allows API access.
    # @return [Sc2::Player] player with active connection
    attr_accessor :bot

    # Returns static [Api::UnitTypeData] for a unit
    # @return [Api::UnitTypeData]
    def unit_data
      @bot.data.units[unit_type]
    end

    # Get the unit as from the previous frame. Good for comparison.
    # @return [Api::Unit, nil] this unit from the previous frame or nil if it wasn't present
    def previous
      @bot.previous.all_units[tag]
    end

    # Attributes ---

    # Returns static [Api::UnitTypeData] for a unit
    # @return [Array<Api::Attribute>]
    def attributes
      unit_data.attributes
    end

    # Checks unit data for an attribute value
    # @return [Boolean] whether unit has attribute
    # @example
    #   has_attribute?(Api::UnitTypeId::SCV, Api::Attribute::Mechanical)
    #   has_attribute?(units.workers.first, :Mechanical)
    #   has_attribute?(Api::UnitTypeId::SCV, :Mechanical)
    def has_attribute?(attribute)
      attributes.include? attribute
    end

    # Checks if unit is light
    # @return [Boolean] whether unit has attribute :Light
    def is_light?
      has_attribute?(:Light)
    end

    # Checks if unit is armored
    # @return [Boolean] whether unit has attribute :Armored
    def is_armored?
      has_attribute?(:Armored)
    end

    # Checks if unit is biological
    # @return [Boolean] whether unit has attribute :Biological
    def is_biological?
      has_attribute?(:Biological)
    end

    # Checks if unit is mechanical
    # @return [Boolean] whether unit has attribute :Mechanical
    def is_mechanical?
      has_attribute?(:Mechanical)
    end

    # Checks if unit is robotic
    # @return [Boolean] whether unit has attribute :Robotic
    def is_robotic?
      has_attribute?(:Robotic)
    end

    # Checks if unit is psionic
    # @return [Boolean] whether unit has attribute :Psionic
    def is_psionic?
      has_attribute?(:Psionic)
    end

    # Checks if unit is massive
    # @return [Boolean] whether unit has attribute :Massive
    def is_massive?
      has_attribute?(:Massive)
    end

    # Checks if unit is structure
    # @return [Boolean] whether unit has attribute :Structure
    def is_structure?
      has_attribute?(:Structure)
    end

    # Checks if unit is hover
    # @return [Boolean] whether unit has attribute :Hover
    def is_hover?
      has_attribute?(:Hover)
    end

    # Checks if unit is heroic
    # @return [Boolean] whether unit has attribute :Heroic
    def is_heroic?
      has_attribute?(:Heroic)
    end

    # Checks if unit is summoned
    # @return [Boolean] whether unit has attribute :Summoned
    def is_summoned?
      has_attribute?(:Summoned)
    end

    # @!group Virtual properties

    # Helpers for unit properties

    def width = radius * 2
    # @!parse
    #   # @!attribute width
    #   # width = radius * 2
    #   # @return [Float]
    #   attr_reader :width

    # Some overrides to allow question mark references to boolean properties

    # @!attribute [r] is_flying?
    #   @return [Boolean] Unit is currently flying.
    def is_flying? = is_flying

    # @!attribute [r] is_burrowed?
    #   @return [Boolean] Zerg burrowed ability active on unit.
    def is_burrowed? = is_burrowed

    # @!attribute [r] is_hallucination?
    #   @return [Boolean] Unit is your own or detected as a hallucination.
    def is_hallucination? = is_hallucination

    # @!attribute [r] is_selected?
    #   @return [Boolean] Whether unit is selected visually or on Feature layer.
    def is_selected? = is_selected

    # @!attribute [r] is_on_screen?
    #   @return [Boolean] Visible and within the camera frustrum.
    def is_on_screen? = is_on_screen

    # @!attribute [r] is_blip?
    #   @return [Boolean] Detected by sensor tower
    def is_blip? = is_blip

    # @!attribute [r] is_powered?
    #   @return [Boolean] Protoss building is powered by a source.
    def is_powered? = is_powered

    # @!attribute [r] is_active?
    #   @return [Boolean] Building is training/researching (i.e. animated).
    def is_active? = is_active

    # @!attribute [r] is_ground?
    # Returns whether the unit is grounded (not flying).
    # @return [Boolean]
    def is_ground? = !is_flying?

    # @!endgroup Virtual properties

    # @!group Actions

    # Performs action on this unit
    # @param ability_id [Integer]
    # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
    # @param queue_command [Boolean] shift+command
    def action(ability_id:, target: nil, queue_command: false)
      @bot.action(units: self, ability_id:, target:, queue_command:)
    end

    # Shorthand for performing action SMART (right-click)
    # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
    # @param queue_command [Boolean] shift+command
    def smart(target: nil, queue_command: false)
      action(ability_id: Api::AbilityId::SMART, target:, queue_command:)
    end

    # Shorthand for performing action MOVE
    # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
    # @param queue_command [Boolean] shift+command
    def move(target:, queue_command: false)
      action(ability_id: Api::AbilityId::MOVE, target:, queue_command:)
    end

    # Shorthand for performing action STOP
    # @param queue_command [Boolean] shift+command
    def stop(queue_command: false)
      action(ability_id: Api::AbilityId::STOP, queue_command:)
    end

    # Shorthand for performing action HOLDPOSITION
    # @param queue_command [Boolean] shift+command
    def hold(queue_command: false)
      action(ability_id: Api::AbilityId::HOLDPOSITION, queue_command:)
    end
    alias_method :hold_position, :hold

    # Shorthand for performing action ATTACK
    # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
    # @param queue_command [Boolean] shift+command
    def attack(target:, queue_command: false)
      action(ability_id: Api::AbilityId::ATTACK, target:, queue_command:)
    end

    # Inverse of #attack, where you target self using another unit (source_unit)
    # @param units [Api::Unit, Sc2::UnitGroup] a unit or unit group
    # @param queue_command [Boolean] shift+command
    # @return [void]
    def attack_with(units:, queue_command: false)
      return unless units.is_a?(Api::Unit) || units.is_a?(Sc2::UnitGroup)

      units.attack(target: self, queue_command:)
    end

    # Builds target unit type, i.e. issuing a build command to worker.build(...Api::UnitTypeId::BARRACKS)
    # @param unit_type_id [Integer] Api::UnitTypeId the unit type which will do the creation
    # @param target [Api::Point2D, Integer, nil] is a unit tag or a Api::Point2D. Nil for addons/orbital
    # @param queue_command [Boolean] shift+command
    def build(unit_type_id:, target: nil, queue_command: false)
      @bot.build(units: self, unit_type_id:, target:, queue_command:)
    end

    # This structure creates a unit, i.e. this Barracks trains a Marine
    # @see #build
    alias_method :train, :build
    # def train(unit_type_id:, target: nil, queue_command: false)
    #   @bot.build(units: self, unit_type_id:, target:, queue_command:)
    # end

    # Issues repair command on target
    # @param target [Api::Unit, Integer] is a unit or unit tag
    def repair(target:, queue_command: false)
      action(ability_id: Api::AbilityId::EFFECT_REPAIR, target:, queue_command:)
    end

    # @!endgroup Actions
    #
    # Debug ----

    # Draws a placement outline
    # @param color [Api::Color] optional api color, default white
    # @return [void]
    def debug_draw_placement(color = nil)
      # Slightly elevate the Z position so that the line doesn't clip into the terrain at same Z level
      z_elevated = pos.z + 0.01
      offset = footprint_radius
      # Box corners
      p0 = Api::Point.new(x: pos.x - offset, y: pos.y - offset, z: z_elevated)
      p1 = Api::Point.new(x: pos.x - offset, y: pos.y + offset, z: z_elevated)
      p2 = Api::Point.new(x: pos.x + offset, y: pos.y + offset, z: z_elevated)
      p3 = Api::Point.new(x: pos.x + offset, y: pos.y - offset, z: z_elevated)
      @bot.queue_debug_command Api::DebugCommand.new(
        draw: Api::DebugDraw.new(
          lines: [
            Api::DebugLine.new(
              color:,
              line: Api::Line.new(p0:, p1:)
            ),
            Api::DebugLine.new(
              color:,
              line: Api::Line.new(p0: p2, p1: p3)
            ),
            Api::DebugLine.new(
              color:,
              line: Api::Line.new(p0:, p1: p3)
            ),
            Api::DebugLine.new(
              color:,
              line: Api::Line.new(p0: p1, p1: p2)
            )
          ]
        )
      )
    end

    # Draws a sphere around the unit's attack range
    # @param weapon_index [Api::Color] default first weapon, see UnitTypeData.weapons
    # @param color [Api::Color] optional api color, default red
    def debug_fire_range(weapon_index = 0, color = nil)
      color = Api::Color.new(r: 255, b: 0, g: 0) if color.nil?
      attack_range = unit_data.weapons[weapon_index].range
      raised_position = pos.dup
      raised_position.z += 0.01
      @bot.debug_draw_sphere(point: raised_position, radius: attack_range, color:)
    end

    # Geometric/Map/Micro functions ---

    # Calculates the distance between self and other
    # @param other [Sc2::Position, Api::Unit, Api::PowerSource, Api::RadarRing, Api::Effect]
    def distance_to(other)
      return 0.0 if other.nil? || other == self

      other = other.pos unless other.is_a? Sc2::Position
      pos.distance_to(other)
    end

    # Gets the nearest amount of unit(s) from a group, relative to this unit
    # Omitting amount returns a single Unit.
    # @param units [Sc2::UnitGroup]
    # @param amount [Integer]
    # @return [Sc2::UnitGroup, Api::Unit, nil] return group or a Unit if amount is not passed
    def nearest(units:, amount: nil)
      amount = 1 if !amount.nil? && amount.to_i <= 0

      # Performs suboptimal if sending an array. Don't.
      if units.is_a? Array
        units = Sc2::UnitGroup.new(units)
        units.use_kdtree = false # we will not re-use it's distance cache
      end

      units.nearest_to(pos:, amount:)
    end

    # Detects whether a unit is within a given circle
    # @param point [Api::Point2D, Api::Point]
    def in_circle?(point:, radius:)
      distance_to(point) <= radius
    end

    # Returns whether unit is currently engaged with another
    # @param target [Api::Unit, Integer] optionally check if unit is engaged with specific target
    def is_attacking?(target: nil)
      is_performing_ability_on_target?(
        [Api::AbilityId::ATTACK_ATTACK],
        target:
      )
    end

    # Returns whether the unit's current order is to repair and optionally check it's target
    # @param target [Api::Unit, Integer] optionally check if unit is engaged with specific target
    # @return [Boolean]
    def is_repairing?(target: nil)
      is_performing_ability_on_target?(
        [Api::AbilityId::EFFECT_REPAIR, Api::AbilityId::EFFECT_REPAIR_SCV, Api::AbilityId::EFFECT_REPAIR_MULE],
        target:
      )
    end

    # Checks whether the unit has
    # @param ability_ids [Integer, Array<Integer>] accepts one or an array of Api::AbilityId
    def is_performing_ability?(ability_ids)
      return false if orders.empty?

      if ability_ids.is_a? Array
        ability_ids.include?(orders.first&.ability_id)
      else
        ability_ids == orders.first&.ability_id
      end
    end

    # Returns whether engaged_target_tag or the current order matches supplied unit
    # @param unit [Api::Unit, Integer] optionally check if unit is engaged with specific target
    # @return [Boolean]
    def is_engaged_with?(unit)
      # First match on unit#engaged_target_tag, since it's solid for attacks
      unit = unit.tag if unit.is_a? Api::Unit
      return true if engaged_target_tag == unit

      # Alternatively, check your order to see if your command ties you to the unit
      # It may not be in distance or actively performing, just yet.
      return orders.first.target_unit_tag == unit unless orders.empty?

      false
    end

    # Checks whether enemy is within range of weapon or ability and can target ground/air.
    # Defaults to basic weapon. Pass in ability to override
    # @param unit [Api::Unit] enemy
    # @param weapon_index [Integer] defaults to 0 which is it's basic weapon for it's current form
    # @param ability_id [Integer] passing this will override weapon Api::AbilityId::*
    # @return [Boolean]
    # @example
    #   ghost.can_attack?(enemy, weapon_index: 0, ability_id: Api::AbilityId::SNIPE)
    def can_attack?(unit:, weapon_index: 0, ability_id: nil)
      if ability_id.nil?
        # weapon
        source_weapon = weapon(weapon_index)
        can_weapon_target_unit?(unit:, weapon: source_weapon)
      else
        # ability
        ability = @bot.ability_data(ability_id)
        can_ability_target_unit?(unit:, ability:)
      end
    end

    # Checks whether a weapon can target a unit
    # @param unit [Api::unit]
    # @param weapon [Api::Weapon]
    # @return [Boolean]
    def can_weapon_target_unit?(unit:, weapon:)
      # false if enemy is air and we can only shoot ground
      return false if unit.is_flying && weapon.type == :Ground # Api::Weapon::TargetType::Ground

      # false if enemy is ground and we can only shoot air
      return false if unit.is_ground? && weapon.type == :Air # A pi::Weapon::TargetType::Air

      # Check if weapon and unit models are in range
      in_attack_range?(unit:, range: weapon.range)
    end

    def can_ability_target_unit?(unit:, ability:)
      # false if enemy is air and we can only shoot ground
      return false if ability.target == Api::AbilityData::Target::None

      # Check if weapon and unit models are in range
      in_attack_range?(unit:, range: ability.cast_range)
    end

    # Checks whether opposing unit is in the attack range.
    # @param unit [Api::Unit]
    # @param range [Float, nil] nil. will use default weapon range if nothing provided
    # @return [Boolean]
    def in_attack_range?(unit:, range: nil)
      range = weapon.range if range.nil?
      distance_to(unit) <= radius + unit.radius + range
    end

    # Gets a weapon for this unit at index (default weapon is index 0)
    # @param index [Integer] default 0
    # @return [Api::Weapon]
    def weapon(index = 0)
      unit_data.weapons[index]
    end

    # Macro functions ---

    # For saturation counters on bases or gas, get the amount of missing harvesters required to saturate.
    # For a unit to which this effect doesn't apply, the amount is zero.
    # @return [Integer] number of harvesters required to saturate this structure
    def missing_harvesters
      return 0 if ideal_harvesters.zero?

      missing = ideal_harvesters - assigned_harvesters
      missing.positive? ? missing : 0
    end

    # The placement size, by looking up unit's creation ability, then game ability data
    # This value should be correct for building placement math (unit.radius is not good for this)
    # @return [Float] placement radius
    def footprint_radius
      @bot.data.abilities[unit_data.ability_id].footprint_radius
    end

    # Returns true if build progress is 100%
    # @return [Boolean]
    def is_completed?
      build_progress == 1.0 # standard:disable Lint/FloatComparison
    end

    # Convenience functions ---

    # TERRAN Convenience functions ---

    # Returns the Api::Unit add-on (Reactor/Tech Lab), if present for this structure
    # @return [Api::Unit, nil] the unit if an addon is present or nil if not present
    def add_on
      @add_on ||= @bot.structures[add_on_tag]
    end

    # Returns whether the structure has a reactor add-on
    # @return [Boolean] if the unit has a reactor attached
    def has_reactor
      Sc2::UnitGroup::TYPE_REACTOR.include?(add_on&.unit_type)
    end

    # Returns whether the structure has a tech lab add-on
    # @example
    #   # Find the first Starport with a techlab
    #   sp = structures.select_type(Api::UnitTypeId::STARPORT).find(&:has_tech_lab)
    #   # Get the actual tech-lab with #add_on
    #   sp.add_on.research ...
    # @return [Boolean] if the unit has a tech lab attached
    def has_tech_lab
      Sc2::UnitGroup::TYPE_TECHLAB.include?(add_on&.unit_type)
    end

    # For Terran builds a tech lab add-on on the current structure
    # @return [void]
    def build_reactor(queue_command: false)
      build(unit_type_id: Api::UnitTypeId::REACTOR, queue_command:)
    end

    # For Terran builds a tech lab add-on on the current structure
    # @return [void]
    def build_tech_lab(queue_command: false)
      build(unit_type_id: Api::UnitTypeId::TECHLAB, queue_command:)
    end

    # GENERAL Convenience functions ---

    # ...

    private

    # @private
    # Reduces repetition in the is_*action*?(target:) methods
    def is_performing_ability_on_target?(abilities, target: nil)
      # Exit if not actioning the ability
      return false unless is_performing_ability?(abilities)

      # If a target was given and we're targeting it, us that value
      return is_engaged_with?(target) unless target.nil?

      true
    end
  end
end
Api::Unit.include Api::UnitExtension
