# TUTORIAL 1

Work in progress. Due soon.   
  
Here's some example actions, queries and debug commands in the meantime.  
Run this bot and see if you can spot the actions it performs.  

I bet you can do better than this! :)


-Dyson, Jan 23
  
  
```ruby
require "sc2ai"

# Naive Protoss Stalker attack, with TechTree usage and one Query
class MyBot < Sc2::Player::Bot
  def on_step

    if structures.hq.first.nil?
      leave_game
    end

    main_pos = structures.hq.first.pos
    main = structures.hq.first

    # Train a probe
    if structures.hq.first.missing_harvesters > 0 && common.minerals > 50
      main.train(unit_type_id: Api::UnitTypeId::PROBE)
    end

    # Build a pylon if supply is low
    if common.food_used > (common.food_cap - 10) && common.minerals >= 100
      worker = units.workers.random

      build_target = geo.build_placement_near(length: 7, target: main_pos)
      worker.build(unit_type_id: Api::UnitTypeId::PYLON,
                   target: build_target)
      worker.smart(target: neutral.minerals.nearest_to(pos: worker.pos), queue_command: true)
    end

    # Get some gas
    if structures.gas.size < 2 && can_afford?(unit_type_id: Api::UnitTypeId::ASSIMILATOR)
      worker = units.workers.random
      worker.smart(target: neutral.minerals.nearest_to(pos: worker), queue_command: true)

      # nearest geysers to main hq
      gasses = main.nearest(units: neutral.geysers.units.values, amount: 2)
      units.workers.build(unit_type_id: Api::UnitTypeId::ASSIMILATOR, target: gasses.random)
    end

    # Populate gas structure with probes
    structures.gas.select(&:is_completed?).each do |gas|
      missing_harvesters = gas.missing_harvesters
      next if missing_harvesters.zero?

      gas.nearest(units: units.workers, amount: missing_harvesters)
         .each { |worker| worker.action(ability_id: Api::AbilityId::SMART, target: gas) }
    end if game_loop % 6 == 0 # only check every couple of frames


    # Add gateways if we don't have any or every 60s (±1344 frames)
    gates = structures.select_type(Api::UnitTypeId::GATEWAY)
    if (gates.size == 0 || game_loop % 1344 == 0) && can_afford?(unit_type_id: Api::UnitTypeId::GATEWAY)
      worker = units.workers.random
      build_location = geo.build_placement_near(length: 4, target: structures.pylons.random.pos, random: 3)
      worker.build(unit_type_id: Api::UnitTypeId::GATEWAY,
                   target: build_location)
      worker.smart(target: worker.nearest(units: neutral.minerals), queue_command: true)
    end

    # Build cyber core, to get warp tech.
    cores = structures.select_type(Api::UnitTypeId::CYBERNETICSCORE)
    if gates.size > 0 && cores.size < 1
      worker = units.workers.random
      build_location = geo.build_placement_near(length: 4, target: main_pos, random: 3)
      worker.build(unit_type_id: Api::UnitTypeId::CYBERNETICSCORE, target: build_location)
      worker.smart(target: worker.nearest(units: neutral.minerals), queue_command: true)
    end

    # Research warp tech
    if cores.count(&:is_completed?) > 0 && !@warp_researched
      cores.action(ability_id: Api::AbilityId::RESEARCH_WARPGATE)
      # Setting a flag for ourselves. It's bad to perform redundant actions each frame
      @warp_researched = true
    end

    # Morph gateways to warpgates
    if gates.count(&:is_completed?) > 0
      gates.action(ability_id: Api::AbilityId::MORPH_WARPGATE)
    end

    # Get the ability ID for warping a stalker. This could be hardcoded too.
    build_stalker_ability_id = Api::TechTree.unit_type_creation_abilities(
      source: Api::UnitTypeId::WARPGATE,
      target: Api::UnitTypeId::STALKER
    )
    build_stalker_ability_id = build_stalker_ability_id[:ability]

    # If we have gates, Query the game to see if we have the warp-stalker ability
    if structures.warpgates.count(&:is_completed?) > 0
      abilities = @api.query_abilities_for_unit_tags(structures.warpgates.first.tag)
      can_build_stalker = abilities.abilities.any? do |ability|
        ability.ability_id == build_stalker_ability_id
      end

      if can_build_stalker && can_afford?(unit_type_id: Api::UnitTypeId::STALKER, quantity: 5)
        points = geo.warp_points(source: structures.warpables.first,
                                 unit_type_id: Api::UnitTypeId::STALKER)

        points = points.min_by(5) { |p| p.distance_to(game_info.start_raw.start_locations.first) }
        points.each do |point|
          structures.warpgates.warp(unit_type_id: Api::UnitTypeId::STALKER, target: point)
        end
      end

    end

    # If we are floating tons of minerals, expand
    if common.minerals > 1500
      worker = units.workers.random
      build_location = geo.expansions_unoccupied.keys.min_by { |point| point.distance_to(main_pos) }
      worker.build(unit_type_id: Api::UnitTypeId::NEXUS, target: build_location)
      worker.smart(target: worker.nearest(units: neutral.minerals), queue_command: true)
    end
    
    # New expansions should target the nearest mineral as rally
    structures.hq.reject(&:is_completed?).each do |nexus|
      nearby_mineral = nexus.nearest(units: neutral.minerals)
      nexus.action(ability_id: Api::AbilityId::RALLY_WORKERS,
                             target: nearby_mineral)
      # Let's mark it visually to debug. Can you see the red sphere in-game?
      debug_draw_sphere(point: nearby_mineral.pos, color: Api::Color.new(r: 255, g: 0, b: 0))
    end

    # If we have 10 stalkers, let's attack
    if units.army.size >= 10
      units.army.attack(target: game_info.start_raw.start_locations.first)
    end
  end
end

Sc2::Match.new(
  players: [
    MyBot.new(name: "StalkerExample", race: Api::Race::Protoss),
    Sc2::Player::Computer.new(race: Api::Race::Random, difficulty: Api::Difficulty::VeryEasy)
  ],
  map: "Goldenaura512AIE"
).run

```