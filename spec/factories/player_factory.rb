# frozen_string_literal: true

FactoryBot.define do
  factory :player, class: "Sc2::Player" do
    race { Api::Race::Random }
    name { "Player" }

    transient do
      type { Api::PlayerType::Participant }
      difficulty { Api::Difficulty::Hard }
      ai_build { Api::AIBuild::RandomBuild }
    end

    initialize_with { new(race:, name:, type:, difficulty:, ai_build:) }

    factory :player_bot, class: Sc2::Player::Bot.name do
      initialize_with { new(race:, name:) }
    end

    factory :player_human, class: Sc2::Player::Human.name do
      initialize_with { new(race:, name:) }
    end

    factory :player_computer, class: Sc2::Player::Computer.name do
      initialize_with { new(race:, name:, difficulty:, ai_build:) }
    end
  end
end
