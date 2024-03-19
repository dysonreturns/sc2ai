# frozen_string_literal: true

module Sc2
  # A collection of Api::Unit, which acts as a hash of unit.tag => unit.
  # Consider a UnitGroup a virtual Control Group.
  # Most Hash operations like select/filter, reject, etc. are implemented to return a UnitGroup to to allow fluent group control
  class UnitGroup
    extend Forwardable
    include Enumerable

    # @!attribute units
    # A hash of units by tag.
    #   @return [Hash<Integer, Api::Unit>] Api::Unit.tag => Api::Unit
    attr_accessor :units

    # @param units [Api::Unit, Hash<Integer, Api::Unit>, Array<Api::Unit>, Sc2::UnitGroup, nil] default to be added.
    # @return Sc2::UnitGroup new unit group
    def initialize(units = nil)
      @units = {}
      case units
      when Array, Google::Protobuf::RepeatedField
        units.each do |unit|
          @units[unit.tag] = unit
        end
      when Hash
        @units = units
      when UnitGroup
        @units = units.units
      else
        # noop
      end

      @_cache_hash = {}
      @_cache = {}
    end

    # @!macro [attach] def_delegators
    #   @!method $2
    #     Forwards to hash of #units.
    #     @see Hash#$2
    def_delegator :@units, :empty? # Returns whether there are no entries.
    def_delegator :@units, :eql? # Returns whether a given object is equal to #units.
    def_delegator :@units, :length # Returns the count of entries.
    def_delegator :@units, :size # Returns the count of entries.

    # @!macro [attach] def_delegators
    #   @!method $2
    #     Forwards to hash of #units.
    #     @see Hash#$2
    def_delegator :@units, :< # Returns whether #units is a proper subset of a given object.
    def_delegator :@units, :<= # Returns whether #units is a subset of a given object.
    def_delegator :@units, :== # Returns whether a given object is equal to #units.
    def_delegator :@units, :> # Returns whether #units is a proper superset of a given object
    def_delegator :@units, :>= # Returns whether #units is a proper superset of a given object.

    # @!macro [attach] def_delegators
    #   @!method $2
    #     Forwards to hash of #units.
    #     @see Hash#$2
    def_delegator :@units, :[] # Returns the value associated with the given key, if found
    def_delegator :@units, :keys # Returns an array containing all keys in #units.
    def_delegator :@units, :values # Returns an array containing all values in #units.
    def_delegator :@units, :values_at # Returns an array containing values for given tags in #units.

    # @!macro [attach] def_delegators
    #   @!method $2
    #     Forwards to hash of #units.
    #     @see Hash#$2
    def_delegator :@units, :clear # Removes all entries from #units.
    def_delegator :@units, :delete_if # Removes entries selected by a given block.
    def_delegator :@units, :select! # Keep only those entries selected by a given block
    def_delegator :@units, :filter! # Keep only those entries selected by a given block
    def_delegator :@units, :keep_if # Keep only those entries selected by a given block
    # def_delegator :@units, :compact! # Removes all +nil+-valued entries from #units.

    # find_all, #filter, #select: Returns elements selected by the block.

    def_delegator :@units, :reject! # Removes entries selected by a given block.
    def_delegator :@units, :shift # Removes and returns the first entry.

    def_delegator :@units, :to_a # Returns a new array of 2-element arrays; each nested array contains a key-value pair from #units
    def_delegator :@units, :to_h # Returns {UnitGroup#units}
    def_delegator :@units, :to_hash # Returns {UnitGroup#units}
    def_delegator :@units, :to_proc # Returns a proc that maps a given key to its value.Returns a proc that maps a given key to its value.

    # Methods which return unit
    # @!macro [attach] def_delegators
    #   @!method $2
    #     Forwards to hash of #units.
    #     @see Hash#$2
    #     @return [Api::Unit]
    def_delegator :@units, :find # Returns an element selected by the block.
    def_delegator :@units, :detect # Returns an element selected by the block.

    # Gets the Unit at an index
    # @return [Api::Unit]
    def at(index)
      @units[tags.at(index)]
    end

    # Meta documentation methods
    # @!method first
    #   @return [Api::Unit]
    # @!method last
    #   @return [Api::Unit]

    # Calls the given block with each Api::Unit value
    # @example
    #   unit_group.each {|unit| puts unit.tag } #=> 1234 ...
    #
    #   unit_group.each do |unit|
    #      puts unit.tag #=> 1234 ...
    #   end
    def each(&)
      @units.each_value(&)
    end

    # Calls the given block with each key-value pair
    # @return [self] a new unit group with items merged
    # @example
    #   unit_group.each {|tag, unit| puts "#{tag}: #{unit}"} #=> "12345: #<Api::Unit ...>"
    #
    #   unit_group.each do |tag, unit|
    #      puts "#{tag}: #{unit}"} #=> "12345: #<Api::Unit ...>"
    #   end
    def each_with_tag(&)
      @units.each(&)
      self
    end

    # Checks whether this group contains a unit.
    # @param unit [Api::Unit, Integer] a unit or a tag.
    # @return [Boolean] A boolean indicating if the #units include? unit.
    def contains?(unit)
      tag = unit.is_a?(Api::Unit) ? unit.tag : unit
      @units.include?(tag)
    end

    # Associates a given unit tag with a given unit.
    # @see UnitGroup#add #add, which is easier to just pass an Api::Unit
    def []=(unit_tag, unit)
      return if unit_tag.nil? || unit.nil?
      @units[unit_tag] = unit
    end

    # Adds a unit or units to the group.
    # @param units [Api::Unit, Array<Api::Unit>, Sc2::UnitGroup]
    # @return [self]
    def add(units)
      case units
      when Api::Unit
        @units[units.tag] = units
      when Array
        units.each do |unit|
          @units[unit.tag] = unit
        end
      when Hash
        @units.merge(units.units)
      when UnitGroup
        @units.merge(units)
      else
        # noop
      end
      @units
    end

    alias_method :push, :add

    # Remove a another UnitGroup's units from ours or a singular Api::Unit either by object or Api::Unit#tag
    # @param unit_group_unit_or_tag [Sc2::UnitGroup, Api::Unit, Integer, nil]
    # @return [Hash<Integer, Api::Unit>, Api::Unit, nil] the removed item(s) or nil
    def remove(unit_group_unit_or_tag)
      case unit_group_unit_or_tag
      when Sc2::UnitGroup
        @units.reject! { |tag, _unit| unit_group_unit_or_tag.units.has_key?(tag) }
      when Api::Unit
        @units.delete(unit_group_unit_or_tag.tag)
      when Integer
        # noinspection RubyMismatchedArgumentType
        @units.delete(unit_group_unit_or_tag)
      else
        # noop
      end
    end

    alias_method :delete, :remove

    # Creates a new unit group which is the result of the two being subtracted
    # @param other_unit_group [UnitGroup]
    # @return [UnitGroup] new unit group
    def subtract(other_unit_group)
      UnitGroup.new(@units.reject { |tag, _unit| other_unit_group.units.has_key?(tag) })
    end

    # Merges unit_group with our units and returns a new unit group
    # @return [Sc2::UnitGroup] a new unit group with items merged
    def merge(unit_group)
      UnitGroup.new(@units.merge(unit_group))
    end
    alias_method :+, :merge

    # Merges unit_group.units into self.units and returns self
    # @return [self]
    def merge!(unit_group)
      @units.merge!(unit_group.units)
      self
    end

    # Replaces the entire contents of #units with the contents of a given unit_group.
    # Synonymous with self.units = unit_group.units
    # @return [void]
    def replace(unit_group)
      @units = unit_group.units
    end

    # Returns a new UnitGroup object whose #units entries are those for which the block returns a truthy value
    # @return [Sc2::UnitGroup] new unit group
    # noinspection RubyMismatchedReturnType # UnitGroup acts as an array, so sig is ok.
    def select
      result = @units.select { |_tag, unit| yield unit }
      UnitGroup.new(result)
    end

    alias_method :filter, :select

    # Returns a new UnitGroup object whose entries are all those from #units for which the block returns false or nil
    # @return [Sc2::UnitGroup] new unit group
    # noinspection RubyMismatchedReturnType # UnitGroup acts as an array, so sig is ok.
    def reject(&block)
      result = @units.reject { |_tag, unit| yield unit }
      UnitGroup.new(result)
    end

    # Returns a copy of self with units removed for specified tags.
    # @return [Sc2::UnitGroup] new unit group
    def except(...)
      UnitGroup.new(@units.except(...))
    end

    # Returns a hash containing the entries for given tag(s).
    # @return [Sc2::UnitGroup] new unit group
    def slice(...)
      UnitGroup.new(@units.slice(...))
    end

    # Selects a single random Unit without a parameter or an array of Units with a param, i.e. self.random(2)
    # @return [Api::Unit]
    def sample(...)
      @units.values.sample(...)
    end
    alias_method :random, :sample

    # def select_or(*procs)
    #   result = UnitGroup.new
    #   procs.each do |proc|
    #     selected = select(&proc)
    #     result.merge!(selected) unless selected.nil?
    #   end
    #   result
    # end

    # Returns an array of unit tags
    # @return [Array<Integer>] array of unit#tag
    def tags
      keys
    end

    class << self
    end

    private

    # @private
    # Caches a block based on key and current UnitGroup#units.hash
    # If the hash changes (units are modified) the cache expires
    # This allows lazy lookups which only fires if the units change
    # Allows, i.e. Player#units.workers to fire only the first time it's called per frame
    def cached(key)
      if @_cache_hash[key] != @units.hash
        @_cache_hash[key] = @units.hash
        @_cache[key] = yield
      end
      @_cache[key]
    end

    attr_accessor :_cache_hash
    attr_accessor :_cache
  end
end

require_relative "unit_group/action_ext"
require_relative "unit_group/filter_ext"
