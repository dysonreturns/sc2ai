# frozen_string_literal: true

RSpec.describe Sc2::Match do
  include_context "player"
  include_context "map"

  context "when configuring" do
    it "resolves valid map string to Map object" do
      match_with_map_name = build(:match, map: "mapname")
      expect(match_with_map_name.map).to be_a(Sc2::MapFile)
    end
  end

  context "when validating" do
    let(:match_without_players) { build(:match) }
    let(:match_with_1player) { build(:match, players: [player_human]) }

    context "players" do
      it "fails when there are no players" do
        expect do
          match_without_players.validate
        end.to raise_error(Sc2::Error)
      end

      it "fails when there is only 1 player" do
        match_without_players.players.push
        expect do
          match_without_players.validate
        end.to raise_error(Sc2::Error)
      end
    end

    context "maps" do
      let(:match_needs_client_without_map) { build(:match, players: [player_bot, player_computer]) }

      it "fails when needing local clients, but no map present" do
        expect do
          match_needs_client_without_map.validate
        end.to raise_error Sc2::Error
      end
    end
  end

  context "when running" do
    before do
      allow_any_instance_of(Sc2::Player).to receive(:connect).and_return(false)
    end

    let(:match_valid) { build(:match, players: [player_bot, player_computer], map: map_relative_path) }

    it "attempts auto port config" do
      # Prevent everything that would make a match do actions
      allow_any_instance_of(Sc2::Ports).to receive(:port_config_auto)
      allow(match_valid).to receive(:connect_players)
      allow(match_valid).to receive(:autosave_replay)
      allow(map_relative_path).to receive(:path).and_return("/dev/null")

      allow_any_instance_of(Sc2::Player).to receive(:create_game)
      allow_any_instance_of(Sc2::Player).to receive(:join_game)
      allow_any_instance_of(Sc2::Player).to receive(:add_listener)
      allow_any_instance_of(Sc2::Player::Bot).to receive(:play)
      allow_any_instance_of(Sc2::ClientManager).to receive(:get).and_return(Sc2::Client.new(host: "", port: 0))
      allow(Sc2::Ports).to receive(:port_config_auto)

      match_valid.run
      expect(Sc2::Ports).to have_received(:port_config_auto)
    end

    it "falls back to auto port config" do
      allow(Sc2::Ports).to receive(:port_config_basic)
      allow(Sc2::Ports).to receive(:port_config_auto).and_invoke(-> { raise Sc2::Error })

      match_valid.send(:port_config)
      expect(Sc2::Ports).to have_received(:port_config_basic)
    end

    describe "#connect_players" do
      it "launches an instance per api_player" do
      end
    end
  end
end
