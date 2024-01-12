# frozen_string_literal: true

RSpec.describe Sc2::Ports do
  describe "#port_config_basic" do
    # This is a ladder convention used in community
    it "counts from start_port for number of players to determine ports" do
      num_players = 2
      start_port = 5000
      server_game_port = start_port + 2 # 5002
      server_base_port = start_port + 3
      client_game_port = start_port + 4
      client_base_port = start_port + 5 # 5005

      port_config = described_class.port_config_basic(
        start_port:,
        num_players:
      )

      expect(port_config.start_port).to eq(start_port)
      expect(port_config.server_port_set.game_port).to eq(server_game_port)
      expect(port_config.server_port_set.base_port).to eq(server_base_port)
      expect(port_config.client_port_sets[0].game_port).to eq(client_game_port)
      expect(port_config.client_port_sets[0].base_port).to eq(client_base_port)
    end
  end

  describe "#port_config_auto" do
    it "finds a random open port range" do
      # not so random ports
      random_ports = (5002..5005).to_a
      start_port = random_ports.first - 2
      server_game_port = random_ports[0] # 5002
      server_base_port = random_ports[1]
      client_game_port = random_ports[2]
      client_base_port = random_ports[3] # 5005
      random_addresses = random_ports.map { |_port| Addrinfo.tcp("0.0.0.0", random_ports.shift.to_s) }

      # return out controlled addresses
      allow_any_instance_of(Socket).to receive(:local_address).and_return(*random_addresses)

      port_config = described_class.port_config_auto(num_players: 2)
      expect(port_config.start_port).to eq(start_port)
      expect(port_config.server_port_set.game_port).to eq(server_game_port)
      expect(port_config.server_port_set.base_port).to eq(server_base_port)
      expect(port_config.client_port_sets[0].game_port).to eq(client_game_port)
      expect(port_config.client_port_sets[0].base_port).to eq(client_base_port)
    end
  end
end
