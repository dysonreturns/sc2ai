# frozen_string_literal: true

FactoryBot.define do
  factory :map, class: Sc2::MapFile.name do
    name { "" }

    initialize_with { new(name) }
  end
end
