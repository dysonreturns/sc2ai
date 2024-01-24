# frozen_string_literal: true

require "sc2ai/unit_group"
require "kdtree"

module Sc2
  # Manage virtual control groups of units, similar to Hash or Array.
  class UnitGroup
    TYPE_WORKER = [Api::UnitTypeId::SCV, Api::UnitTypeId::MULE, Api::UnitTypeId::DRONE, Api::UnitTypeId::DRONEBURROWED, Api::UnitTypeId::PROBE].freeze
    TYPE_GAS_STRUCTURE = [
      Api::UnitTypeId::REFINERY,
      Api::UnitTypeId::REFINERYRICH,
      Api::UnitTypeId::ASSIMILATOR,
      Api::UnitTypeId::ASSIMILATORRICH,
      Api::UnitTypeId::EXTRACTOR,
      Api::UnitTypeId::EXTRACTORRICH
    ].freeze
    TYPE_MINERAL = [
      Api::UnitTypeId::MINERALCRYSTAL,
      Api::UnitTypeId::RICHMINERALFIELD,
      Api::UnitTypeId::RICHMINERALFIELD750,
      Api::UnitTypeId::MINERALFIELD,
      Api::UnitTypeId::MINERALFIELD450,
      Api::UnitTypeId::MINERALFIELD750,
      Api::UnitTypeId::LABMINERALFIELD,
      Api::UnitTypeId::LABMINERALFIELD750,
      Api::UnitTypeId::PURIFIERRICHMINERALFIELD,
      Api::UnitTypeId::PURIFIERRICHMINERALFIELD750,
      Api::UnitTypeId::PURIFIERMINERALFIELD,
      Api::UnitTypeId::PURIFIERMINERALFIELD750,
      Api::UnitTypeId::BATTLESTATIONMINERALFIELD,
      Api::UnitTypeId::BATTLESTATIONMINERALFIELD750,
      Api::UnitTypeId::MINERALFIELDOPAQUE,
      Api::UnitTypeId::MINERALFIELDOPAQUE900
    ].freeze
    TYPE_GEYSER = [
      Api::UnitTypeId::VESPENEGEYSER,
      Api::UnitTypeId::SPACEPLATFORMGEYSER,
      Api::UnitTypeId::RICHVESPENEGEYSER,
      Api::UnitTypeId::PROTOSSVESPENEGEYSER,
      Api::UnitTypeId::PURIFIERVESPENEGEYSER,
      Api::UnitTypeId::SHAKURASVESPENEGEYSER
    ].freeze
    TYPE_REJECT_DEBRIS = ((TYPE_MINERAL + TYPE_GEYSER) << Api::UnitTypeId::XELNAGATOWER).freeze
    TYPE_TECHLAB = [
      Api::UnitTypeId::TECHLAB,
      Api::UnitTypeId::BARRACKSTECHLAB,
      Api::UnitTypeId::FACTORYTECHLAB,
      Api::UnitTypeId::STARPORTTECHLAB
    ].freeze
    TYPE_REACTOR = [
      Api::UnitTypeId::REACTOR,
      Api::UnitTypeId::BARRACKSREACTOR,
      Api::UnitTypeId::FACTORYREACTOR,
      Api::UnitTypeId::STARPORTREACTOR
    ].freeze
    TYPE_BASES = [
      Api::UnitTypeId::COMMANDCENTER, Api::UnitTypeId::COMMANDCENTERFLYING,
      Api::UnitTypeId::ORBITALCOMMAND, Api::UnitTypeId::ORBITALCOMMANDFLYING,
      Api::UnitTypeId::PLANETARYFORTRESS,
      Api::UnitTypeId::HATCHERY, Api::UnitTypeId::HIVE, Api::UnitTypeId::LAIR,
      Api::UnitTypeId::NEXUS
    ].freeze
    # Returns a new UnitGroup containing all units matching unit type id(s)
    # Multiple values work as an "OR" filter
    # @example
    #   # Single
    #   ug.select_type(Api::UnitTypeId::MARINE) #=> <UnitGroup: ...>
    #   # Multiple - select space-men
    #   ug.select_type([Api::UnitTypeId::MARINE, Api::UnitTypeId::REAPER]) #=> <UnitGroup: ...>
    # @param unit_type_ids [Integer, Array<Integer>] one or an array of unit Api::UnitTypeId
    # @return [UnitGroup]
    def select_type(unit_type_ids)
      cached("#{__method__}:#{unit_type_ids.hash}") do
        if unit_type_ids.is_a? Array
          select { |unit| unit_type_ids.include?(unit.unit_type) }
        else
          select { |unit| unit_type_ids == unit.unit_type }
        end
      end
    end

    # Returns a new UnitGroup excluding all units matching unit type id(s)
    # @example
    #   # Single
    #   ug.reject_type(Api::UnitTypeId::SCV) #=> <UnitGroup: ...>
    #   # Multiple - reject immovable army
    #   ug.reject_type([Api::UnitTypeId::SIEGETANKSIEGED, Api::UnitTypeId::WIDOWMINEBURROWED]) #=> <UnitGroup: ...>
    # @param unit_type_ids [Integer, Array<Integer>] one or an array of unit Api::UnitTypeId
    # @return [UnitGroup]
    def reject_type(unit_type_ids)
      cached("#{__method__}:#{unit_type_ids.hash}") do
        if unit_type_ids.is_a? Array
          reject { |unit| unit_type_ids.include?(unit.unit_type) }
        else
          reject { |unit| unit_type_ids == unit.unit_type }
        end
      end
    end

    # Creates a negative selector, which will perform the opposite on the current scope
    #   for it's next select_type/reject_type call.
    # @example
    #   structures.not.creep_tumors #=> all structures
    #   structures.not.pylons #=>
    #   units.not.workers # equivalent of units.army, but works too
    # @return [Sc2::UnitGroupNotSelector]
    def not
      UnitGroupNotSelector.new(self)
    end

    # @private
    # Negative selector allowing unit group "ug.not." filter
    class UnitGroupNotSelector < UnitGroup
      attr_accessor :parent

      def initialize(unit_group)
        @parent = unit_group
        super
      end

      # @private
      # Does the opposite of selector and returns those values for parent
      def select_type(*)
        @parent.reject_type(*)
      end

      # Does the opposite of selector and returns those values for parent
      def reject_type(*)
        @parent.select_type(*)
      end
    end

    # Returns a new UnitGroup containing all units matching attribute id(s)
    # Multiple values work as an "AND" filter
    # @example
    #   # Single
    #   ug.select_attribute(Api::Attribute::Structure) #=> <UnitGroup: ...>
    #   ug.select_attribute(:Structure) #=> <UnitGroup: ...>
    #   # Multiple - select mechanical flying units
    #   ug.select_attribute([:Mechanical, :Flying]) #=> <UnitGroup: ...>
    # @param attributes [Integer, Array<Integer>] one or an array of unit Api::UnitTypeId
    # @return [UnitGroup]
    def select_attribute(attributes)
      cached("#{__method__}:#{attributes.hash}") do
        attributes = [attributes] unless attributes.is_a? Array
        attributes = attributes.map { |a| a.is_a?(Symbol) ? a : Api::Attribute.lookup(a) }
        select do |unit|
          attributes & unit.attributes == attributes
        end
      end
    end

    # Returns a new UnitGroup containing all units excluding attribute id(s)
    # Multiple values work as an "AND" filter
    # @example
    #   # Single
    #   ug.reject_attribute(Api::Attribute::Structure) #=> <UnitGroup: ...>
    #   ug.reject_attribute(:Structure) #=> <UnitGroup: ...>
    #   # Multiple - reject mechanical flying units
    #   ug.reject_attribute(:Mechanical, :Flying) #=> <UnitGroup: ...>
    # @param attributes [Integer, Array<Integer>] one or an array of unit Api::UnitTypeId
    # @return [UnitGroup]
    def reject_attribute(attributes)
      cached("#{__method__}:#{attributes.hash}") do
        attributes = [attributes] unless attributes.is_a? Array
        attributes = attributes.map { |a| a.is_a?(Symbol) ? a : Api::Attribute.lookup(a) }
        reject do |unit|
          unit.attributes & attributes == attributes
        end
      end
    end

    # GENERICS ---

    # Selects worker units
    # @return [Sc2::UnitGroup] workers
    def workers
      select_type(TYPE_WORKER)
    end

    # Selects non army units workers. Generally run on Sc2::Player#units
    # @example in the Player context
    #   fighters = units.army
    #   enemy_fighters = units.army
    # @return [Sc2::UnitGroup] army
    # @see #non_army_unit_type_ids to modify filters
    def army
      reject_type(non_army_unit_type_ids)
    end

    # Selects units with attribute Structure
    # @return [Sc2::UnitGroup] structures
    def structures
      select_attribute(Api::Attribute::Structure)
    end

    # Contains an array non-army types
    # Override to remove or add units you want units.army to exclude
    # @example
    #   # i.e. to have units.army to exclude Overseers
    #   @non_army_unit_types.push(Api::UnitTypeId::OVERSEER)
    #   # i.e. to have units.army to include Queens
    #   @non_army_unit_types.delete(Api::UnitTypeId::QUEEN)
    #   @non_army_unit_types.delete(Api::UnitTypeId::QUEENBURROWED)
    def non_army_unit_type_ids
      @non_army_unit_type_ids ||= TYPE_WORKER + [
        Api::UnitTypeId::QUEEN, Api::UnitTypeId::QUEENBURROWED,
        Api::UnitTypeId::OVERLORD, Api::UnitTypeId::OVERLORDCOCOON,
        Api::UnitTypeId::LARVA
      ]
    end

    # Selects command posts (CC, OC, PF, Nexus, Hatch, Hive, Lair)
    # Aliases are #hq and #townhalls
    # @return [Sc2::UnitGroup] unit group of workers
    def bases
      select_type(TYPE_BASES)
    end
    alias_method :hq, :bases # short name
    alias_method :townhalls, :bases # bad name

    # Selects gas structures (refinery/extractor/assimilator)
    # @return [UnitGroup] gas structures
    def gas
      select_type(TYPE_GAS_STRUCTURE)
    end
    alias_method :refineries, :gas
    alias_method :extractors, :gas
    alias_method :assimilators, :gas

    # NEUTRAL ------------------------------------------

    # Selects mineral fields
    # @return [Sc2::UnitGroup] mineral fields
    # @example
    #   # Typically a Player selects via group @neutral
    #   @neutral.minerals
    def minerals
      select_type(TYPE_MINERAL)
    end

    # Selects gas geysers
    # @return [Sc2::UnitGroup] gas geysers
    # @example
    #   # Typically a Player selects via group @neutral
    #   @neutral.geysers
    def geysers
      select_type(TYPE_GEYSER)
    end

    # Selects xel'naga watchtowers
    # @return [Sc2::UnitGroup] watchtowers
    # @example
    #   # Typically a Player selects via group @neutral
    #   @neutral.watchtowers
    def watchtowers
      select_type(Api::UnitTypeId::XELNAGATOWER)
    end

    # Reverse filters our minerals, geysers and towers to get what is hopefully debris
    # @return [Sc2::UnitGroup] debris
    # @example
    #   # Typically a Player selects via group @neutral
    #   @neutral.debris
    def debris
      reject_type(TYPE_REJECT_DEBRIS)
    end

    # ZERG ------------------------------------------
    # Selects larva units
    # @return [Sc2::UnitGroup] larva
    def larva
      select_type(Api::UnitTypeId::LARVA)
    end
    alias_method :larvae, :larva

    # Selects queens
    # @return [Sc2::UnitGroup] queens
    def queens
      select_type([Api::UnitTypeId::QUEEN, Api::UnitTypeId::QUEENBURROWED])
    end

    # Selects overlords
    # @return [Sc2::UnitGroup]
    def overlords
      select_type([Api::UnitTypeId::OVERLORD, Api::UnitTypeId::OVERLORDCOCOON])
    end

    # Selects creep tumors (all)
    # CREEPTUMORQUEEN is still building & burrowing
    # while CREEPTUMOR was spread from another tumor still building & burrowing
    # and CREEPTUMORBURROWED are burrowed tumors which have already spread or can still spread more
    # @see #creep_tumors_burrowed for those ready to be spread
    # @return [Sc2::UnitGroup] all tumors
    def creep_tumors
      select_type([Api::UnitTypeId::CREEPTUMORQUEEN, Api::UnitTypeId::CREEPTUMOR, Api::UnitTypeId::CREEPTUMORBURROWED])
    end
    alias_method :tumors, :creep_tumors

    # Selects creep tumors which are burrowed.
    # Burrowed tumors have already been spread or are spread-ready.
    # No way to distinguish spreadable tumors without manual tracking.
    # @return [Sc2::UnitGroup] burrowed tumors (with and without spread ability)
    def creep_tumors_burrowed
      select_type(Api::UnitTypeId::CREEPTUMORBURROWED)
    end

    # Protoss ---

    # Selects pylons
    # @return [Sc2::UnitGroup] pylons
    def pylons
      select_type(Api::UnitTypeId::PYLON)
    end

    # Selects warp gates (not gateways)
    # @return [Sc2::UnitGroup] warp gates
    def warpgates
      select_type(Api::UnitTypeId::WARPGATE)
    end

    # Selects pylons and warp prisms in phasing mode
    # @return [Sc2::UnitGroup] pylons annd warp prisms phasing
    def warpables
      select_type([Api::UnitTypeId::PYLON, Api::UnitTypeId::WARPPRISMPHASING])
    end

    # Geometric/Map ---

    # Whether we should be building a kdtree
    # Added to allow the disabling of this property
    # i.e. allows optimization of not to build if group is too big:
    #   return @units.size > 200
    # If you don't do a lot of repeat filtering and don't get gains from repeated searches
    # then override the attribute and set this to: @units.size > 120
    # @return [Boolean]
    attr_accessor :use_kdtree

    # Builds a kdtree if not already built and returns it
    # @return [Kdtree]
    def kdtree
      return @kdtree unless @kdtree.nil?
      @kdtree = Kdtree.new(@units.values.each_with_index.map { |unit, index| [unit.pos.x, unit.pos.y, index] })
    end

    # Returns an
    # @param pos [Sc2::Position] unit.pos or a point of any kind
    # @return [Sc2::UnitGroup, Api::Unit, nil] return group or single unit if amount is not supplied
    def nearest_to(pos:, amount: nil)
      return UnitGroup.new if !amount.nil? && amount.to_i <= 0

      if use_kdtree
        if amount.nil?
          index = kdtree.nearest(pos.x, pos.y)
          return @units.values[index]
        else
          result_indexes = kdtree.nearestk(pos.x, pos.y, amount)
          return UnitGroup.new(@units.values.values_at(*result_indexes))
        end
      end

      # Traditional array min_by with distance calcs on the fly
      if amount.nil?
        # noinspection RubyMismatchedReturnType
        @units.values.min_by { |unit| unit.distance_to(pos) }
      else
        UnitGroup.new(@units.values.min_by(amount) { |unit| unit.distance_to(pos) })
      end
    end

    # Selects units which are in a particular circle
    # @param point [Api::Point2D, Api::Point] center of circle
    # @param radius [Float]
    def select_in_circle(point:, radius:)
      select { |unit| unit.in_circle?(point:, radius:) }
    end
  end
end
