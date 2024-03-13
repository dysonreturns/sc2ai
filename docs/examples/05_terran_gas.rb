require "sc2ai"

Sc2.config do |config|
  config.version = "4.10"
end

class ExampleTerran < Sc2::Player::Bot
  def configure
    # 01 - Step size
    @step_count = 2
  end

  def on_step
    main_base = structures.hq.first
    return if main_base.nil?

    # 02 - Construct an SCV
    if can_afford?(unit_type_id: Api::UnitTypeId::SCV)

      workers_in_progress = main_base.orders.size
      if workers_in_progress == 0
        # Scenario 1: Queue is empty, lets build
        main_base.build(unit_type_id: Api::UnitTypeId::SCV)
      elsif workers_in_progress == 1 && main_base.orders.first.progress > 0.9
        # Scenario 2: Queue has one unit, which is almost completed (== 1.0), so let's start another
        main_base.build(unit_type_id: Api::UnitTypeId::SCV)
      end

    end

    # 03 - Construct buildings

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
      build_location = geo.build_placement_near(length: 3, target: main_base, random: 3)

      # Tell worker to build at location
      builder.build(unit_type_id: Api::UnitTypeId::SUPPLYDEPOT, target: build_location)

      # 04 - Queue command
      nearest_mineral = neutral.minerals.nearest_to(pos: build_location)
      builder.smart(target: nearest_mineral, queue_command: true)
    end

    # 05 - Gas

    # Get geysers for main
    geysers_for_main = geo.geysers_for_base(main_base)
    # Get gas structures for main
    gasses = geo.gas_for_base(main_base)

    # If we haven't taken as many gasses as there are geysers
    if gasses.size < geysers_for_main.size
      # For each geyser...
      geysers_for_main.each do |geyser|
        # ensure we can afford a refinery or break the loop
        break unless can_afford?(unit_type_id: Api::UnitTypeId::REFINERY)

        # and build a refinery on-top of the geyser position
        units.workers.random.build(unit_type_id: Api::UnitTypeId::REFINERY, target: geyser)
      end
    end

    # Gas saturation checks - only every 2s in-game (32 frames)
    # Save the game_loop on which we last checked (initially zero)
    @last_saturation_check ||= 0

    # If 32 frames have passed since our last check
    if game_loop - @last_saturation_check >= 32
      # Loop over completed gasses
      gasses.each do |gas|
        # Only check this gas if it's construction is completed
        next unless gas.is_completed?

        # Move on to the next gas if we are not missing harvesters
        next if gas.missing_harvesters.zero?

        # From the 5 nearest workers, randomly select the amount needed and send them to gas
        gas.nearest(units: units.workers, amount: 5)
          .random(gas.missing_harvesters)
          .each { |worker| worker.smart(target: gas) }
      end

      # Update check time
      @last_saturation_check = game_loop
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
