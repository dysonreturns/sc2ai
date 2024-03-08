require "sc2ai"

Sc2.config do |config|
  config.version = "4.10"
end

class ExampleBot < Sc2::Player::Bot
  def configure
    @step_count = 3
  end

  def on_step
    pp "This is game_loop: #{game_loop}"

    #=> "This is game_loop: 0"
    #=> "This is game_loop: 3"
    #=> "This is game_loop: 6"
    #=> "This is game_loop: 9"
    #=> ...
  end
end

Sc2::Match.new(
  players: [
    ExampleTerran.new(name: "ExampleTerran", race: Api::Race::Terran),
    Sc2::Player::Computer.new(name: "CPU", race: Api::Race::Random)
  ],
  map: "SiteDelta512AIE"
).run
