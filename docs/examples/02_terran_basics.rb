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
    base = structures.hq.first

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
  end
end

Sc2::Match.new(
  players: [
    ExampleTerran.new(name: "ExampleTerran", race: Api::Race::Terran),
    Sc2::Player::Computer.new(name: "CPU", race: Api::Race::Random)
  ],
  map: "SiteDelta512AIE"
).run
