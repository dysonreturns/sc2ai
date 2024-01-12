# frozen_string_literal: true

RSpec.describe Sc2::Player do
  include_context "player"

  context "when an instance is available" do
    it "#connect" do
    end
  end

  context "when initializing a Player" do
    it "validates on race" do
      expect do
        build(:player, race: nil)
      end.to raise_error(ArgumentError, "unknown race: ''")
    end

    it "validates on type" do
      expect do
        build(:player, type: nil)
      end.to raise_error(ArgumentError, "unknown type: ''")
    end
  end

  context "when initializing a Bot" do
    it "has type Participant" do
      expect(player_bot.type).to eq(Api::PlayerType::Participant)
    end

    it "#requires_client? true" do
      expect(player_bot.requires_client?).to be(true)
    end
  end

  context "when initializing a Human" do
    it "has type Participant" do
      expect(player_human.type).to eq(Api::PlayerType::Participant)
    end

    it "#requires_client? true" do
      expect(player_human.requires_client?).to be(true)
    end
  end

  context "when initializing a Computer" do
    it "has type Computer" do
      expect(player_computer.type).to eq(Api::PlayerType::Computer)
    end

    it "do not #requires_client?" do
      expect(player_computer.requires_client?).to be(false)
    end

    it "has defaults to difficulty Api::Difficulty::VeryEasy" do
      pc_no_difficulty = build(:player_computer, difficulty: nil)
      expect(pc_no_difficulty.difficulty).to eq(Api::Difficulty::VeryEasy)
    end

    it "has defaults to ai_build Api::AIBuild::RandomBuild" do
      pc_no_build = build(:player_computer, ai_build: nil)
      expect(pc_no_build.ai_build).to eq(Api::AIBuild::RandomBuild)
    end
  end
end
