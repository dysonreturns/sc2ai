# frozen_string_literal: true

RSpec.shared_context "player" do
  let(:player_bot) { build(:player_bot) }
  let(:player_computer) { build(:player_computer) }
  let(:player_human) { build(:player_human) }
end
