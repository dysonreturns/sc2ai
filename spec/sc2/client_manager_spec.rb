# frozen_string_literal: true

RSpec.describe Sc2::ClientManager do
  describe "#start" do
    it "starts an instance" do
      player_index = 0
      described_class.stop(player_index)
      described_class.start(player_index)
      expect(described_class.get(player_index)).not_to be_nil
    end
  end

  describe "#get" do
    it "gets an instance" do
      player_index = 0
      client = described_class.start(player_index)
      expect(described_class.get(player_index)).to eq(client)
    end
  end

  describe "#stop" do
    it "stops an instance" do
      player_index = 0
      client = described_class.start(player_index)
      allow(client).to receive(:stop)
      described_class.stop(player_index)
      expect(client).to have_received(:stop)
      expect(described_class.get(player_index)).to be_nil
    end
  end

  describe "#obtain" do
    after do
      described_class.send(:new)
    end

    it "returns an instance if defined" do
      player_index = 0
      described_class.stop(player_index)
      client_start = described_class.start(player_index)
      allow(client_start).to receive(:running?).and_return(true)
      expect(described_class.obtain(player_index)).to eq(client_start)
    end

    it "starts instance if not defined" do
      player_index = 0
      described_class.stop(player_index)
      allow(described_class.instance).to receive(:start).and_return(Sc2::Client.new(host: "0.0.0.0", port: 123))
      described_class.obtain(player_index)
      expect(described_class.instance).to have_received(:start)
    end
  end
end
