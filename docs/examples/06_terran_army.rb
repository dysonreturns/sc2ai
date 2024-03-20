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
    if main_base.missing_harvesters > 0 && can_afford?(unit_type_id: Api::UnitTypeId::SCV)
      workers_in_progress = main_base.orders.size
      if workers_in_progress == 0
        # Scenario 1: Queue is empty, lets build
        main_base.train(unit_type_id: Api::UnitTypeId::SCV)
      elsif workers_in_progress == 1 && main_base.orders.first.progress > 0.9
        # Scenario 2: Queue has one unit, which is almost completed (== 1.0), so let's start another
        main_base.train(unit_type_id: Api::UnitTypeId::SCV)
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
      .count(&:in_progress?)

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

    # 06 - Army

    # Build barracks if we have a depot, up to a max of 3 per base
    barracks = structures.select_type(Api::UnitTypeId::BARRACKS)
    depots = structures.select_type(Api::UnitTypeId::SUPPLYDEPOT).select(&:is_completed?)

    if depots.size > 0 && barracks.size < 3
      (3 - barracks.size).times do
        # ensure we can afford it
        break unless can_afford?(unit_type_id: Api::UnitTypeId::BARRACKS)

        builder = units.workers.random

        # Use 6-spaced build blocks for a 3x3 structure with a potential a 2x2 add-on and some walking room
        # 3 + 2 + 1 side-walk square = 6
        build_location = geo.build_placement_near(length: 6, target: main_base, random: 3)
        builder.build(unit_type_id: Api::UnitTypeId::BARRACKS, target: build_location)
        builder.smart(target: geo.minerals_for_base(main_base).random, queue_command: true)
      end
    end

    # Build add-ons to completed barracks
    barracks = barracks.select(&:is_completed?) # only focussing on completed barracks...

    # If we can't find a barracks with a tech lab
    if barracks.size > 0 && !barracks.find(&:has_tech_lab?)
      # Build a tech lab
      barracks.random.build_tech_lab if can_afford?(unit_type_id: Api::UnitTypeId::BARRACKSTECHLAB)
    else
      # We have at least one tech lab already, for the rest we add reactors

      # Select without add_on == Reject where add_on present
      barracks.reject(&:add_on).each do |barrack|
        break unless can_afford?(unit_type_id: Api::UnitTypeId::REACTOR)

        # Build a reactor
        barrack.build_reactor
      end
    end

    barracks.each do |barrack|
      # Ensure we have an add-on and that it's completed
      next unless barrack.add_on&.is_completed?

      # If we have a tech lab, build 1x MARAUDER, if a reactor, then 2x MARINES
      if barrack.has_tech_lab?
        unit_type_to_train = Api::UnitTypeId::MARAUDER
        quantity = 1
      else
        unit_type_to_train = Api::UnitTypeId::MARINE
        quantity = 2
      end

      # If our orders are empty or near completion...
      if barrack.orders.size == 0 || barrack.orders.size <= 2 && barrack.orders.any? { |order| order.progress > 0.9 }
        # Send the train command quantity times.
        quantity.times do
          # Note queue_command is true for the reactor, because multiple actions on the same frame overwrite each other.
          barrack.train(unit_type_id: unit_type_to_train, queue_command: true)
        end
      end
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
