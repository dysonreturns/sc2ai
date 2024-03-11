# frozen_string_literal: true

require "rumale/clustering/dbscan"
require "rumale/pairwise_metric"

module Sc2
  class Player
    # Holds map and geography helper functions
    class Geometry
      # @!attribute bot
      #   @return [Sc2::Player] player with active connection
      attr_accessor :bot

      def initialize(bot)
        @bot = bot
      end

      # Gets the map tile width. Range is 1-255.
      # Effected by crop_to_playable_area
      # @return [Integer]
      def map_width
        # bot.bot.game_info
        bot.game_info.start_raw.map_size.x
      end

      # Gets the map tile height. Range is 1-255.
      # Effected by crop_to_playable_area
      # @return [Integer]
      def map_height
        # bot.bot.game_info
        bot.game_info.start_raw.map_size.y
      end

      # Returns zero to map_width as range
      # @return [Range] 0 to map_width
      def map_range_x
        0..(map_width)
      end

      # Returns zero to map_height as range
      # @return [Range] 0 to map_height
      def map_range_y
        0..(map_height)
      end

      # Returns zero to map_width-1 as range
      # @return [Range]
      def map_tile_range_x
        0..(map_width - 1)
      end

      # Returns zero to map_height-1 as range
      # @return [Range]
      def map_tile_range_y
        0..(map_height - 1)
      end

      # Map Parsing functions -----

      # Returns whether a x/y (integer) is placeable as per minimap image data.
      # It does not say whether a position is occupied by another building.
      # One pixel covers one whole block. Corrects floats on your behalf
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Boolean] whether tile is placeable?
      # @see Sc2::Player#pathable? for detecting obstructions
      def placeable?(x:, y:)
        parsed_placement_grid[y.to_i, x.to_i] != 0
      end

      # Returns a parsed placement_grid from bot.game_info.start_raw.
      # Each value in [row][column] holds a boolean value represented as an integer
      # It does not say whether a position is occupied by another building.
      # One pixel covers one whole block. Rounds fractionated positions down.
      # @return [Numo::Bit]
      def parsed_placement_grid
        if @parsed_placement_grid.nil?
          image_data = bot.game_info.start_raw.placement_grid
          # Fix endian for Numo bit parser
          data = image_data.data.unpack("b*").pack("B*")
          @parsed_placement_grid = ::Numo::Bit.from_binary(data, [image_data.size.y, image_data.size.x])
        end
        @parsed_placement_grid
      end

      # Returns a grid where ony the expo locations are marked
      # @return [Numo::Bit]
      def expo_placement_grid
        if @expo_placement_grid.nil?
          @expo_placement_grid = Numo::Bit.zeros(map_height, map_width)
          expansion_points.each do |point|
            x = point.x.floor
            y = point.y.floor
            @expo_placement_grid[(y - 2).clamp(map_tile_range_y)..(y + 2).clamp(map_tile_range_y),
                                 (x - 2).clamp(map_tile_range_y)..(x + 2).clamp(map_tile_range_y)] = 1
          end
        end
        @expo_placement_grid
      end

      # Returns a grid where powered locations are marked true
      # @return [Numo::Bit]
      def parsed_power_grid
        # Cache for based on power unit tags
        cache_key = bot.power_sources.map(&:tag).sort.hash
        return @parsed_power_grid[0] if !@parsed_power_grid.nil? && @parsed_power_grid[1] == cache_key

        result = Numo::Bit.zeros(map_height, map_width)
        power_source = bot.power_sources.first
        if power_source.nil?
          @parsed_power_grid = [result, cache_key]
          return result
        end

        radius = power_source.radius
        radius_tile = radius.ceil

        # Keep this code-block, should we need to make power sources dynamic again:
        # START: Dynamic blueprint
        # # Build a blueprint and mark it everywhere we need to
        # # Lets mark everything as powered with 1 and then disable non-powered with a 0
        # blueprint = Numo::Bit.ones(radius.ceil * 2, radius.ceil * 2)
        # #blueprint[radius_tile, radius_tile] = 0
        # blueprint[(radius_tile - 1)..radius_tile, (radius_tile - 1)..radius_tile] = 0
        # # Loop over top-right quadrant of a circle, so we don't have to +/- for distance calcs.
        # # Additionally, we only measure if in the upper triangle, since the inner is all inside the circle.
        # # Then apply to all four quadrants.
        # quadrant_size = radius_tile - 1
        # point_search_offsets = (0..quadrant_size).to_a.product((0..quadrant_size).to_a)
        # point_search_offsets.each do |y, x|
        #   next if x < quadrant_size - y # Only upper Triangle
        #
        #   dist = Math.hypot(x, y)
        #   if dist >= radius
        #     # Mark as outside x4
        #     blueprint[radius_tile + y, radius_tile + x] = 0
        #     blueprint[radius_tile + y, radius_tile - 1 - x] = 0
        #     blueprint[radius_tile - 1 - y, radius_tile + x] = 0
        #     blueprint[radius_tile - 1 - y, radius_tile - 1 - x] = 0
        #   end
        # end
        # END: Dynamic blueprint ---

        # Hard-coding this shape for pylon power
        # 00001111110000
        # 00111111111100
        # 01111111111110
        # 01111111111110
        # 11111111111111
        # 11111111111111
        # 11111100111111
        # 11111100111111
        # 11111111111111
        # 11111111111111
        # 01111111111110
        # 01111111111110
        # 00111111111100
        # 00001111110000

        # perf: Saving pre-created shape for speed (0.5ms saved) by using hardcode from .to_binary.unpack("C*")
        blueprint_data = [240, 3, 255, 227, 255, 249, 127, 255, 255, 255, 255, 243, 255, 252, 255, 255, 255, 239, 255, 249, 127, 252, 15, 252, 0].pack("C*")
        blueprint = ::Numo::Bit.from_binary(blueprint_data, [radius_tile * 2, radius_tile * 2])

        bot.power_sources.each do |ps|
          x_tile = ps.pos.x.floor
          y_tile = ps.pos.y.floor
          replace_start_x = (x_tile - radius_tile)
          replace_end_x = (x_tile + radius_tile - 1)
          replace_start_y = (y_tile - radius_tile)
          replace_end_y = (y_tile + radius_tile - 1)
          bp_start_x = bp_start_y = 0
          bp_end_x = bp_end_y = blueprint.shape[0] - 1

          # Laborious clamping if blueprint goes over edge
          if replace_start_x < 0
            bp_start_x += replace_start_x
            replace_start_x = 0
          elsif replace_end_x >= map_width
            bp_end_x += map_width - replace_end_x - 1
            replace_end_x = map_width - 1
          end
          if replace_start_y < 0
            bp_start_y += replace_start_y
            replace_start_y = 0
          elsif replace_end_y >= map_height
            bp_end_y += map_height - replace_end_y - 1
            replace_end_y = map_height - 1
          end

          # Bitwise OR because previous pylons could overlap
          result[replace_start_y..replace_end_y, replace_start_x..replace_end_x] = result[replace_start_y..replace_end_y, replace_start_x..replace_end_x] | blueprint[bp_start_y..bp_end_y, bp_start_x..bp_end_x]
        end
        bot.power_sources.each do |ps|
          # For pylons, remove pylon location on ground
          next if bot.structures.pylons[ps.tag].nil?
          result[(ps.pos.y.floor - 1)..ps.pos.y.floor, (ps.pos.x.floor - 1)..ps.pos.x.floor] = 0
        end
        @parsed_power_grid = [result, cache_key]
        result
      end

      # Returns whether a x/y block is powered. Only fully covered blocks are true.
      # One pixel covers one whole block. Corrects float inputs on your behalf.
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Boolean] true if location is powered
      def powered?(x:, y:)
        parsed_power_grid[y.to_i, x.to_i] != 0
      end

      # Returns whether a x/y block is pathable as per minimap
      # One pixel covers one whole block. Corrects float inputs on your behalf.
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Boolean] whether tile is patahble
      def pathable?(x:, y:)
        parsed_pathing_grid[y.to_i, x.to_i] != 0
      end

      # Gets the pathable areas as things stand right now in the game
      # Buildings, minerals, structures, etc. all result in a nonpathable place
      # @example
      #   parsed_pathing_grid[0,0] # reads bottom left corner
      #   # use helper function #pathable
      #   pathable?(x: 0, y: 0) # reads bottom left corner
      # @return [Numo::Bit] Numo array
      def parsed_pathing_grid
        if bot.game_info_stale?
          previous_data = bot.game_info.start_raw.pathing_grid.data
          bot.refresh_game_info
          # Only re-parse if binary strings don't match
          clear_cached_pathing_grid if previous_data != bot.game_info.start_raw.pathing_grid.data
        end

        if @parsed_pathing_grid.nil?
          image_data = bot.game_info.start_raw.pathing_grid
          # Fix endian for Numo bit parser
          data = image_data.data.unpack("b*").pack("B*")
          @parsed_pathing_grid = ::Numo::Bit.from_binary(data, [image_data.size.y, image_data.size.x])
        end
        @parsed_pathing_grid
      end

      # Clears pathing-grid dependent objects like placements.
      # Called when pathing grid gets updated
      #
      private def clear_cached_pathing_grid
        @parsed_pathing_grid = nil
        @_build_coordinates = {}
        @_build_coordinate_tree = {}
      end

      # Returns the terrain height (z) at position x and y
      # Granularity is per placement grid block, since this comes from minimap image data.
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Float] z axis position between -16 and 16
      def terrain_height(x:, y:)
        parsed_terrain_height[y.to_i, x.to_i]
      end

      # Returns a parsed terrain_height from bot.game_info.start_raw.
      # Each value in [row][column] holds a float value which is the z height
      # @return [Numo::SFloat] Numo array
      def parsed_terrain_height
        if @parsed_terrain_height.nil?

          image_data = bot.game_info.start_raw.terrain_height
          @parsed_terrain_height = ::Numo::UInt8.from_binary(image_data.data,
            [image_data.size.y, image_data.size.x])
            .cast_to(Numo::SFloat)

          # Values are between -16 and +16. The api values is a float height compressed to rgb range (0-255) in that range of 32.
          # real_height = -16 + (value / 255) * 32
          # These are the least bulk operations while still letting Numo run the loops:
          @parsed_terrain_height *= (32.0 / 255.0)
          @parsed_terrain_height -= 16.0
        end
        @parsed_terrain_height
      end

      # Returns one of three Integer visibility indicators at tile for x & y
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Integer] 0=Hidden,1= Snapshot,2=Visible
      def visibility(x:, y:)
        parsed_visibility_grid[y.to_i, x.to_i]
      end

      # Returns whether the point (tile) is currently in vision
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Boolean] true if fog is completely lifted
      def map_visible?(x:, y:)
        visibility(x:, y:) == 2
      end

      # Returns whether point (tile) has been seen before or currently visible
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Boolean] true if partially or fully lifted fog
      def map_seen?(x:, y:)
        visibility(x:, y:) != 0
      end

      # Returns whether the point (tile) has never been seen/explored before (dark fog)
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Boolean] true if fog of war is fully dark
      def map_unseen?(x:, y:)
        !map_seen?(x:, y:)
      end

      # Returns a parsed map_state.visibility from bot.observation.raw_data.
      # Each value in [row][column] holds one of three integers (0,1,2) to flag a vision type
      # @see #visibility for reading from this value
      # @return [Numo::SFloat] Numo array
      def parsed_visibility_grid
        if @parsed_visibility_grid.nil?
          image_data = bot.observation.raw_data.map_state.visibility
          @parsed_visibility_grid = ::Numo::UInt8.from_binary(image_data.data,
            [image_data.size.y, image_data.size.x])
        end
        @parsed_visibility_grid
      end

      # Returns whether a tile has creep on it, as per minimap
      # One pixel covers one whole block. Corrects float inputs on your behalf.
      # @param x [Float, Integer]
      # @param y [Float, Integer]
      # @return [Boolean] true if location has creep on it
      def creep?(x:, y:)
        parsed_creep[y.to_i, x.to_i] != 0
      end

      # Provides parsed minimap representation of creep spread
      # @return [Numo::Bit] Numo array
      def parsed_creep
        if @parsed_creep.nil?
          image_data = bot.observation.raw_data.map_state.creep
          # Fix endian for Numo bit parser
          data = image_data.data.unpack("b*").pack("B*")
          @parsed_creep = ::Numo::Bit.from_binary(data, [image_data.size.y, image_data.size.x])
        end
        @parsed_creep
      end

      # TODO: Removing. Better name or more features for this? Maybe check nearest units.
      # Checks map data for placeability (without querying api)
      # You can manually query this instead for potential better results with
      # @see Sc2::Connection::Requests#query_placements for a slow (5ms) alternative
      # @return [Boolean] whether coordinate is placeable and pathable
      # def can_place?(x:, y:)
      #   placeable?(x: x, y: y) && pathable?(x: x, y: y)
      # end

      # TODO: Remove this method if it has no use. Build points uses this code directly for optimization.
      # Reduce the dimensions of a grid by merging cells using length x length squares.
      # Merged cell keeps it's 1 value only if all merged cells are equal to 1, else 0
      # @param input_grid [Numo::Bit] Bit grid like parsed_pathing_grid or parsed_placement_grid
      # @param length [Integer] how many cells to merge, i.e. 3 for finding 3x3 placement
      def divide_grid(input_grid, length)
        height = input_grid.shape[0]
        width = input_grid.shape[1]

        new_height = height / length
        new_width = width / length

        # Assume everything is placeable. We will check and set 0's below
        output_grid = Numo::Bit.ones(new_height, new_width)

        # divide map into tile length and remove remainder blocks
        capped_height = new_height * length
        capped_width = new_width * length

        # These loops are all structured this way, because of speed.
        y = 0
        while y < capped_height
          x = 0
          while x < capped_width
            # We are on the bottom-left of a placement tile of Length x Length
            # Check right- and upwards for any negatives and break both loops, as soon as we find one
            inner_y = 0
            while inner_y < length
              inner_x = 0
              while inner_x < length
                if (input_grid[y + inner_y, x + inner_x]).zero?
                  output_grid[y / length, x / length] = 0
                  inner_y = length
                  break
                end
                inner_x += 1
              end
              inner_y += 1
            end
            # End of checking sub-cells

            x += length
          end
          y += length
        end
        output_grid
      end

      # Gets expos and surrounding minerals
      # The index is a build location for an expo and the value is a UnitGroup, which has minerals and geysers
      # @example
      #   random_expo = geo.expansions.keys.sample #=> Point2D
      #   expo_resources = geo.expansions[random_expo] #=> UnitGroup
      #   alive_minerals = expo_resources.minerals & neutral.minerals
      #   geysers = expo_resources.geysers
      # @return [Hash<Api::Point2D, UnitGroup>] Location => UnitGroup of resources (minerals+geysers)
      def expansions
        return @expansions unless @expansions.nil?

        @expansions = {}

        # An array of offsets to search around the center of resource cluster for points
        point_search_offsets = (-7..7).to_a.product((-7..7).to_a)
        point_search_offsets.select! do |x, y|
          dist = Math.hypot(x, y)
          dist > 4 && dist <= 8
        end

        # Split resources by Z axis
        resources = bot.neutral.minerals + bot.neutral.geysers
        resource_group_z = resources.group_by do |resource|
          resource.pos.z.round # 32 units of Y, most maps will have use 3. round to nearest.
        end

        # Cluster over every z level
        resource_group_z.map do |z, resource_group|
          # Convert group into numo array of 2d points
          positions = Numo::DFloat.zeros(resource_group.size, 2)
          resource_group.each_with_index do |res, index|
            positions[index, 0] = res.pos.x
            positions[index, 1] = res.pos.y
          end
          # Max 8.5 distance apart for nodes, else it's noise. At least 4 resources for an expo
          analyzer = Rumale::Clustering::DBSCAN.new(eps: 8.5, min_samples: 4)
          cluster_marks = analyzer.fit_predict(positions)

          # for each cluster, grab those indexes to reference the mineral/gas
          # then work out a placeable position based on their locations
          (0..cluster_marks.max).each do |cluster_index|
            clustered_resources = resource_group.select.with_index { |_res, i| cluster_marks[i] == cluster_index }
            possible_points = {}

            # Grab center of clustered
            avg_x = clustered_resources.sum { |res| res.pos.x } / clustered_resources.size
            avg_y = clustered_resources.sum { |res| res.pos.y } / clustered_resources.size
            # Round average spot to nearest 0.5 point, since HQ center is at half measure (5 wide)
            avg_x = avg_x.round + 0.5
            avg_y = avg_y.round + 0.5

            points_length = point_search_offsets.length
            i = 0
            while i < points_length
              x = point_search_offsets[i][0] + avg_x
              y = point_search_offsets[i][1] + avg_y

              if !map_tile_range_x.include?(x + 1) || !map_tile_range_y.include?(y + 1)
                i += 1
                next
              end

              if parsed_placement_grid[y.floor, x.floor].zero?
                i += 1
                next
              end

              # Compare this point to each resource to ensure it's far enough away
              distance_sum = 0
              valid_min_distance = clustered_resources.all? do |res|
                dist = Math.hypot(res.pos.x - x, res.pos.y - y)
                if Sc2::UnitGroup::TYPE_GEYSER.include?(res.unit_type)
                  min_distance = 7
                  distance_sum += (dist / 7.0) * dist
                else
                  min_distance = 6
                  distance_sum += dist
                end
                dist >= min_distance
              end
              possible_points[[x, y]] = distance_sum if valid_min_distance

              i += 1
            end
            # Choose best fitting point
            best_point = possible_points.keys[possible_points.values.find_index(possible_points.values.min)]
            @expansions[best_point.to_p2d] = UnitGroup.new(clustered_resources)
          end
        end
        @expansions
      end

      # Returns a list of 2d points for expansion build locations
      # Does not contain mineral info, but the value can be checked against geo.expansions
      #
      # @example
      #   random_expo = expansion_points.sample
      #   expo_resources = geo.expansions[random_expo]
      # @return [Array<Api::Point2D>] points where expansions can be placed
      def expansion_points
        expansions.keys
      end

      # Returns a slice of #expansions where a base hasn't been built yet
      # @example
      #   # Lets find the nearest unoccupied expo
      #   expo_pos = expansions_unoccupied.keys.min { |p2d| p2d.distance_to(structures.hq.first) }
      #   # What minerals/geysers does it have?
      #   puts expansions_unoccupied[expo_pos].minerals # or expansions[expo_pos]... => UnitGroup
      #   puts expansions_unoccupied[expo_pos].geysers # or expansions[expo_pos]... => UnitGroup
      # @return [Hash<Api::Point2D], UnitGroup] Location => UnitGroup of resources (minerals+geysers)
      def expansions_unoccupied
        taken_bases = bot.structures.hq.map { |hq| hq.pos.to_p2d } + bot.enemy.structures.hq.map { |hq| hq.pos.to_p2d }
        remaining_points = expansion_points - taken_bases
        expansions.slice(*remaining_points)
      end

      # Gets minerals for a base or base position
      # @param base [Api::Unit, Sc2::Position] base Unit or Position
      # @return [Sc2::UnitGroup] UnitGroup of minerals for the base
      def minerals_for_base(base)
        resources_for_base(base).minerals
      end

      # Gets geysers for a base or base position
      # @param base [Api::Unit, Sc2::Position] base Unit or Position
      # @return [Sc2::UnitGroup] UnitGroup of geysers for the base
      def geysers_for_base(base)
        resources_for_base(base).geysers
      end

      # @private
      # @param base [Api::Unit, Sc2::Position] base Unit or Position
      # @return [Sc2::UnitGroup] UnitGroup of resources (minerals+geysers)
      private def resources_for_base(base)
        pos = base.is_a?(Api::Unit) ? base.pos : base

        # If we have a base setup for this exact position, use it
        if expansions.has_key?(pos)
          return expansions[pos]
        end

        # Tolerance for misplaced base: Find the nearest base to this position
        pos = expansion_points.min_by { |p| p.distance_to(pos) }
        expansions[pos]
      end


      # Gets buildable point grid for squares of size, i.e. 3 = 3x3 placements
      # Uses pathing grid internally, to ignore taken positions
      # Does not query the api and is generally fast.
      # @param length [Integer] length of the building, 2 for depot/pylon, 3 for rax/gate
      # @param on_creep [Boolean] whether this build location should be on creep
      # @return [Array<Array<(Float, Float)>>] Array of [x,y] tuples
      def build_coordinates(length:, on_creep: false, in_power: false)
        length = 1 if length < 1
        @_build_coordinates ||= {}
        cache_key = [length, on_creep].hash
        return @_build_coordinates[cache_key] if !@_build_coordinates[cache_key].nil? && !bot.game_info_stale?

        result = []
        input_grid = parsed_pathing_grid & parsed_placement_grid & ~expo_placement_grid
        input_grid = parsed_creep & input_grid if on_creep
        input_grid = parsed_power_grid & input_grid if in_power

        # Dimensions
        height = input_grid.shape[0]
        width = input_grid.shape[1]

        # divide map into tile length and remove remainder blocks
        capped_height = height / length * length
        capped_width = width / length * length

        # Build points are in center of square, i.e. 1.5 inwards for a 3x3 building
        offset_to_inside = length / 2.0

        # Note, these loops are structured for speed
        y = 0
        while y < capped_height
          x = 0
          while x < capped_width
            # We are on the bottom-left of a placement tile of Length x Length
            # Check right- and upwards for any negatives and break both loops, as soon as we find one
            valid_position = true
            inner_y = 0
            while inner_y < length
              inner_x = 0
              while inner_x < length
                if (input_grid[y + inner_y, x + inner_x]).zero?
                  # break sub-cells check and don't save position
                  valid_position = false
                  inner_y = length
                  break
                end
                inner_x += 1
              end
              inner_y += 1
            end
            # End of checking sub-cells

            result << [x + offset_to_inside, y + offset_to_inside] if valid_position
            x += length
          end
          y += length
        end
        @_build_coordinates[cache_key] = result
      end

      # Gets a buildable location for a square of length, near target. Chooses from random amount of nearest locations.
      # For robustness, it is advised to set `random` to, i.e. 3, to allow choosing the 3 nearest possible places, should one location be blocked.
      # For zerg, the buildable locations are only on creep.
      # Internally creates a kdtree for building locations based on pathable, placeable and creep
      # @param length [Integer] length of the building, 2 for depot/pylon, 3 for rax/gate
      # @param target [Api::Unit, Sc2::Position] near where to find a placement
      # @param random [Integer] number of nearest points to randomly choose from. 1 for nearest point.
      # @return [Api::Point2D, nil] buildable location, nil if no buildable location found
      def build_placement_near(length:, target:, random: 1)
        target = target.pos if target.is_a? Api::Unit
        random = 1 if random.to_i.negative?
        length = 1 if length < 1
        on_creep = bot.race == Api::Race::Zerg

        coordinates = build_coordinates(length:, on_creep:)
        @_build_coordinate_tree ||= {}
        cache_key = [length, on_creep].hash
        if @_build_coordinate_tree[cache_key].nil?
          @_build_coordinate_tree[cache_key] = Kdtree.new(
            coordinates.each_with_index.map { |coords, index| coords + [index] }
          )
        end
        nearest = @_build_coordinate_tree[cache_key].nearestk(target.x, target.y, random)
        return nil if nearest.nil?

        coordinates[nearest.sample].to_p2d
      end

      # Protoss ------

      # Draws a grid within a unit (pylon/prisms) radius, then selects points which are placeable
      # @param source [Api::Unit] either a pylon or a prism
      # @param unit_type_id [Api::Unit] optionally, the unit you wish to place. Stalkers are widest, so use default nil for a mixed composition warp
      # @return [Array<Api::Point2D>] an array of 2d points where theoretically placeable
      def warp_points(source:, unit_type_id: nil)
        # power source needed
        power_source = bot.power_sources.find { |ps| source.tag == ps.tag }
        return [] if power_source.nil?

        # hardcoded unit radius, otherwise only obtainable by owning a unit already
        unit_type_id = Api::UnitTypeId::STALKER if unit_type_id.nil?
        target_radius = case unit_type_id
        when Api::UnitTypeId::STALKER
          0.625
        when Api::UnitTypeId::HIGHTEMPLAR, Api::UnitTypeId::DARKTEMPLAR
          0.375
        else
          0.5 # Adept, zealot, sentry, etc.
        end
        unit_width = target_radius * 2

        # power source's inner and outer radius
        outer_radius = power_source.radius
        # Can not spawn on-top of pylon
        inner_radius = (source.unit_type == Api::UnitTypeId::PYLON) ? source.radius : 0

        # Make a grid of circles packed in triangle formation, covering the power field
        points = []
        y_increment = Math.sqrt(Math.hypot(unit_width, unit_width / 2.0))
        offset_row = false
        # noinspection RubyMismatchedArgumentType # rbs fixed in future patch
        ((source.pos.y - outer_radius + target_radius)..(source.pos.y + outer_radius - target_radius)).step(y_increment) do |y|
          ((source.pos.x - outer_radius + target_radius)..(source.pos.x + outer_radius - target_radius)).step(unit_width) do |x|
            x += target_radius if offset_row
            points << Api::Point2D[x, y]
          end
          offset_row = !offset_row
        end

        # Select only grid points inside the outer source and outside the inner source
        points.select! do |grid_point|
          gp_distance = source.pos.distance_to(grid_point)
          gp_distance > inner_radius + target_radius && gp_distance + target_radius < outer_radius
        end

        # Find X amount of near units within the radius and subtract their overlap in radius with points
        # we arbitrarily decided that a pylon will no be surrounded by more than 50 units
        # We add 2.75 above, which is the fattest ground unit (nexus @ 2.75 radius)
        units_in_pylon_range = bot.all_units.nearest_to(pos: source.pos, amount: 50)
          .select_in_circle(point: source.pos, radius: outer_radius + 2.75)

        # Reject warp points which overlap with units inside
        points.reject! do |point|
          # Find units which overlap with our warp points
          units_in_pylon_range.find do |unit|
            xd = (unit.pos.x - point.x).abs
            yd = (unit.pos.y - point.y).abs
            intersect_distance = target_radius + unit.radius
            next false if xd > intersect_distance || yd > intersect_distance

            Math.hypot(xd, yd) < intersect_distance
          end
        end

        # Select only warp points which are on placeable tiles
        points.reject! do |point|
          left = (point.x - target_radius).floor.clamp(map_tile_range_x)
          right = (point.x + target_radius).floor.clamp(map_tile_range_x)
          top = (point.y + target_radius).floor.clamp(map_tile_range_y)
          bottom = (point.y - target_radius).floor.clamp(map_tile_range_y)

          unplaceable = false
          x = left
          while x <= right
            break if unplaceable
            y = bottom
            while y <= top
              unplaceable = !placeable?(x: x, y: y)
              break if unplaceable
              y += 1
            end
            x += 1
          end
          unplaceable
        end

        points
      end

      # Geometry helpers  ---

      # Finds points in a straight line.
      # In a line, on the angle of source->target point, starting at source+offset, in increments find points on the line up to max distance
      # @param source [Sc2::Position] location from which we go
      # @param target [Sc2::Position] location towards which we go
      # @param offset [Float] how far from source to start
      # @param increment [Float] how far apart to gets, i.e. increment = unit.radius*2 to space units in a line
      # @param count [Integer] number of points to retrieve
      # @return [Array<Api::Point2D>] points up to a max of count
      def points_nearest_linear(source:, target:, offset: 0.0, increment: 1.0, count: 1)
        # Normalized angle
        dx = (target.x - source.x)
        dy = (target.y - source.y)
        dist = Math.hypot(dx, dy)
        dx /= dist
        dy /= dist

        # Set start position and offset if necessary
        start_x = source.x
        start_y = source.y
        unless offset.zero?
          start_x += (dx * offset)
          start_y += (dy * offset)
        end

        # For count times, increment our radius and multiply by angle to get the new point
        points = []
        i = 1
        while i < count
          radius = increment * i
          point = Api::Point2D[
            start_x + (dx * radius),
            start_y + (dy * radius)
          ]

          # ensure we're on the map
          break unless map_range_x.cover?(point.x) && map_range_y.cover?(point.x)

          points << point
          i += 1
        end

        points
      end

      # Gets a random point near a location with a positive/negative offset applied to both x and y
      # @example
      #   Randomly randomly adjust both x and y by a range of -3.5 or +3.5
      #   geo.point_random_near(point: structures.hq.first, offset: 3.5)
      # @param pos [Sc2::Location]
      # @param offset [Float]
      # @return [Api::Point2D]
      def point_random_near(pos:, offset: 1.0)
        pos.random_offset(offset)
      end

      # @param pos [Sc2::Location]
      # @param radius [Float]
      # @return [Api::Point2D]
      def point_random_on_circle(pos:, radius: 1.0)
        angle = rand(0..360) * Math::PI / 180.0
        Api::Point2D[
          pos.x + (Math.sin(angle) * radius),
          pos.y + (Math.cos(angle) * radius)
        ]
      end
    end
  end
end
