require "sc2ai"

Sc2.config do |config|
  config.version = "4.10"
end

class ExampleTerran < Sc2::Player::Bot
  def configure
    # 01 - Step size
    @step_count = 2
  end

  def on_start
    # Example printing out of map
    geo.parsed_placement_grid.reverse.each_over_axis(0) do |row|
      puts row.to_a.join("")
    end
  end

  def on_step
    base = structures.hq.first

    # 02 - Construct an SCV
    if can_afford?(unit_type_id: Api::UnitTypeId::SCV)

      workers_in_progress = base.orders.size
      if workers_in_progress == 0
        # Scenario 1: Queue is empty, lets build
        base.build(unit_type_id: Api::UnitTypeId::SCV)
      elsif workers_in_progress == 1 && base.orders.first.progress > 0.9
        # Scenario 2: Queue has one unit, which is almost completed (== 1.0), so let's start another
        base.build(unit_type_id: Api::UnitTypeId::SCV)
      end

    end

    # 03 - Construct buildings

    # Print label for main position "^ [x, y]"
    debug_text_world("^ [#{base.pos.x}, #{base.pos.y}]", point: base.pos)

    # Debug all the points for length 3x3 which are buildable
    geo.build_coordinates(length: 3).each do |x, y|
      # To draw in 3d we need a Z-axis, so use the ground height at this point
      z = geo.terrain_height(x: x, y: y)
      build_point = Api::Point[x, y, z]

      # Draw box
      debug_draw_box(point: build_point, radius: 1.5)
      # Draw label
      debug_text_world("^ [#{x}, #{y}]", point: build_point)
    end

    # If we've used up 75% of our supply and can afford a depot, lets build one
    space_is_low = common.food_used.to_f / common.food_cap.to_f > 0.75

    # Hard supply max: 200. Adding more supply buildings this doesn't grow the cap.
    supply_can_grow = common.food_cap < 200

    # Count depots currently under construction
    nr_depots_in_progress = structures
      .select_type(Api::UnitTypeId::SUPPLYDEPOT)
      .count { |depot| !depot.is_completed? }

    if space_is_low &&
        supply_can_grow &&
        nr_depots_in_progress == 0 &&
        can_afford?(unit_type_id: Api::UnitTypeId::SUPPLYDEPOT)

      # Pick a random worker
      builder = units.workers.sample

      # Get location near base 3-spaced for out 2x2 structure to prevent blocking ourselves in.
      build_location = geo.build_placement_near(length: 3, target: base, random: 3)

      # Tell worker to build at location
      builder.build(unit_type_id: Api::UnitTypeId::SUPPLYDEPOT, target: build_location)

      # 04 - Queue command
      nearest_mineral = neutral.minerals.nearest_to(pos: build_location)
      builder.smart(target: nearest_mineral, queue_command: true)

    end
  end
end

Sc2::Match.new(
  players: [
    ExampleTerran.new(name: "ExampleTerran", race: Api::Race::Terran),
    Sc2::Player::Computer.new(name: "CPU", race: Api::Race::Random)
  ],
  map: "SiteDelta512AIE"
).run
