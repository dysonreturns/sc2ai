# frozen_string_literal: true

FactoryBot.define do
  factory :match, class: "Sc2::Match" do
    players { [] }
    transient do
      map { nil }
    end

    initialize_with { new(players:, map:) }
  end
end
