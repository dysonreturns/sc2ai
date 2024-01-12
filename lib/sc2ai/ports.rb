# frozen_string_literal: true

require "socket"

module Sc2
  # Produces suitable PortConfig based on start_port and num_players.
  #   Community-consensus on port usage: where start_port is x
  #   term "start_port" only used for calculation: x
  #   legacy, ignored port: x+1
  #   @server.game_port: x+2, @server.base_port: x+3
  #   below is meant to be repeated, but client only allows 1 additional client. player 2:
  #   @client_ports.game_port: x+4, @client_ports.base_port: x+5
  class Ports
    # @private
    # Random ports previously used
    @used_random_ports = []

    # @private
    # A valid auto-generated port config is only ever used once
    @auto_port_config = nil

    class << self
      # Basic port config using the magic of incrementation on start_port
      # @param start_port [Integer]
      # @param num_players [Integer] Player count which require clients
      # @return [PortConfig] basic port config
      def port_config_basic(start_port:, num_players:)
        PortConfig.new(start_port:,
          num_players:,
          ports: port_range(start_port.to_i + 2, num_players).to_a)
      end

      # Checks system for open ports to get a list of ports for num_players
      # since start_port is purely cosmetic, it's set to the first port, minus two
      # @param num_players [Integer] Player count which require clients
      # @return [PortConfig] new portconfig
      def port_config_auto(num_players:)
        return @auto_port_config unless @auto_port_config.nil?

        if num_players <= 1
          @auto_port_config = PortConfig.new(start_port: 0,
            num_players:,
            ports: [])
          return @auto_port_config
        end

        max_retry = 10
        try = 0

        # First, attempt to grab a random open port and test sequentially ahead
        while try < max_retry
          try += 1

          random_port = random_available_port
          next unless random_port

          random_port_range = port_range(random_port, num_players)
          # Ensure all are available
          next unless random_port_range.detect { |p| !port_available?(p) }.nil?

          start_port = random_port_range.first - 2
          # If so, store and return a port config
          @auto_port_config = PortConfig.new(start_port:,
            num_players:,
            ports: random_port_range.to_a)

          # And memorise our random ports used, for good measure
          @used_random_ports << random_port_range.to_a
          @used_random_ports.uniq!
          return @auto_port_config
        end
      end

      # Checks if port is open
      # @param port [String,Integer] check if open
      def port_available?(port)
        !!bind(port)
      end

      # Checks system for a random available port which we haven't used yet
      # @return [Integer] port
      # @raise [Sc2::Error] error if no free port is found
      def random_available_port
        10.times do
          port = bind(0)
          unless @used_random_ports.include?(port)
            @used_random_ports << port
            return port
          end
        end

        # Alternatively, grab some random ports and check if they are open
        # Try random ports as a last resort.
        10.times do
          port = rand(15_000..25_000)
          if port_available?(port) && !@used_random_ports.include?(port)
            @used_random_ports << port
            return port
          end
        end

        raise Error, "no free ports found"
      end

      private

      # Gets range of ports based on offset and number of players
      # @param from [Integer] (inclusive)
      # @param num_players [Integer]
      # @return [Range] range of ports
      def port_range(from, num_players)
        (from...(from + (num_players * 2)))
      end

      # Will bind tcp port and return port if successful
      # if port is zero, it will return random port bound to
      # @return [Integer, Boolean] port if bind succeeds, false on failure
      def bind(port)
        socket = ::Socket.new(:AF_INET, :SOCK_STREAM, 0)
        socket.bind(Addrinfo.tcp("", port))
        socket.local_address.ip_port
      rescue
        false
      ensure
        # noinspection RubyScope
        socket&.close
        false
      end
    end
  end

  # A port configuration for a Match which allows generating Api::PortSet
  class PortConfig
    attr_reader :start_port, :server_port_set, :client_port_sets

    def initialize(start_port:, num_players:, ports: [])
      @start_port = start_port
      @server_port_set = nil
      @client_port_sets = nil
      return if num_players <= 1

      return if ports.empty?

      @server_port_set = Api::PortSet.new(game_port: ports.shift, base_port: ports.shift)

      @client_port_sets = []
      (num_players - 1).times do
        @client_port_sets << Api::PortSet.new(game_port: ports.shift, base_port: ports.shift)
      end
    end
  end
end
