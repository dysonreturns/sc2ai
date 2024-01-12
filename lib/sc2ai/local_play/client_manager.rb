# frozen_string_literal: true

require "singleton"
require "forwardable"

module Sc2
  # Starts, stops and holds reference to clients
  class ClientManager
    include Singleton

    class << self
      extend Forwardable
      def_delegators :instance, :obtain, :get, :start, :stop
    end

    # Gets client for player X or starts an instance
    def obtain(player_index)
      client = get(player_index)
      if client.nil? || !client.running?
        client = start(player_index)
        @clients[player_index] = client
      end
      client
    end

    # Gets Sc2::Client client for player index
    # @param player_index [Integer] normally 0,1
    # @return [Sc2::Connection, nil] running client or nil if not set
    def get(player_index)
      @clients[player_index]
    end

    # Starts an Sc2 client for player_index. Will stop existing client if present.
    # @param player_index [Integer] normally 0,1
    # @return [Sc2::Client] started client
    def start(player_index)
      existing = @clients[player_index]
      stop(player_index) if !existing.nil? && existing.running?

      client = Client.new(host: @host, port: @ports[player_index], **Sc2.config.to_h)
      client.launch
      @clients[player_index] = client
      client
    end

    # Stops client at player index
    # @param player_index [Integer]
    # @return [void]
    def stop(player_index)
      return unless @clients[player_index]

      @clients[player_index]&.stop
      @clients[player_index] = nil
    end

    private

    attr_accessor :clients, :ports

    def initialize
      super
      @ports = Sc2.config.ports
      @ports = [] unless ports.is_a? Array
      @ports.push(Ports.random_available_port) while @ports.size < 3

      @host = Sc2.config.host
      @clients = []
    end
  end
end
