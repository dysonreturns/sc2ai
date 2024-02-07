# frozen_string_literal: true

require_relative "../connection/status_listener"

module Sc2
  # Runs a match using a map and player configuration
  class Match
    include Sc2::Connection::StatusListener

    # Callback when game status changes
    def on_status_change(status)
      Sc2.logger.debug { "Status from Match: #{status}" }

      # if status == :ended
      #   # Go through each player, looking for result if we don't have one.
      #   api_players.each do |player|
      #     Sc2.logger.debug { "TODO: Get results for players" }
      #     # result = player.result
      #     Sc2.logger.debug { "Leaving Game and Disconnecting players" }
      #     player.leave_game
      #     player.disconnect
      #   end
      # end
    end

    # TODO: DEFINE REALTIME AS A PARAM

    # @!attribute players Sets the Player(s) for the match
    #   @return [Array<Sc2::Player>] an array of assigned players (ai,bots,humans,observers)
    attr_accessor :players

    # @!attribute map Sets the Map for the match
    #   @return [Sc2::MapFile] the Map for the match
    attr_reader :map

    # @param players [Array<Sc2::Player>]
    # @param map [String, Sc2::MapFile] String path or map name, or Map
    # @return [Sc2::Match]
    def initialize(players:, map: nil)
      @players = players || []
      @map = if map.is_a?(String)
        MapFile.new(map.to_s)
      else
        map
      end
    end

    # Validates a runnable match and raises an error if invalid
    # @return [void]
    # @raise [Sc2:Error]
    def validate
      @players.select! { |player| player.is_a?(Player) }
      raise Error, "player count greater than 1 expected" unless @players.length >= 2

      raise Error, "invalid map" if !@map.is_a?(MapFile) || @map.path.empty?
    end

    # Connects players to instances, creates a game and joins everyone to play!
    # @return [void]
    def run
      validate
      Sc2.logger.debug { "Connecting players to client..." }

      # Holds the game process and finishes when a status triggers it to end
      Async do |run_task|
        connect_players
        setup_player_hooks

        player_host.create_game(map:, players: @players)

        api_players.each_with_index do |player, player_index|
          run_task.async do
            player.join_game(
              server_host: ClientManager.get(player_index).host,
              port_config:
            )

            result = player.play
            Sc2.logger.debug { "Player(#{player_index}) Result: #{result}" }
            autosave_replay(player)
          ensure
            Sc2.logger.debug { "Game over, disconnect players." }
            # Suppress interrupt errors #$stderr.reopen File.new(File::NULL, "w")
            player.disconnect
            ClientManager.stop(player_index) # unless keep_clients_alive
          end
        end
      rescue
        # no op - clean exit from game may cause ws disconnection error
      end.wait

      nil
    end

    private

    # Saves the replay from the player's perspective.
    # Requires active client and connection.
    def autosave_replay(player)
      safe_player_name = player.name.gsub(/\s*[^A-Za-z0-9.-]\s*/, "_").downcase

      response = player.api.save_replay
      path = Pathname(Paths.bot_data_replay_dir).join("autosave-#{safe_player_name}.SC2Replay")
      f = File.new(path, "wb:ASCII-8BIT")
      f.write(response.data)
      f.close
    end

    # Gets a PortConfig
    # @return [Sc2::PortConfig] port configuration based on players
    def port_config
      # Sc2.logger.debug { "Get port config..." }
      # Detect open ports
      @port_config = Ports.port_config_auto(num_players: api_players.length)
    rescue
      # Fall back to increment method
      @port_config = Ports.port_config_basic(start_port: 5000, num_players: api_players.length)
    end

    # def prepare_clients
    #   Async do |task|
    #     api_players.each_with_index do |player, i|
    #       Sc2.logger.debug { "Obtain client for player #{i}: #{player.class}, #{player.name}"
    #       ClientManager.obtain(i)
    #     end
    #   end
    # end

    # Gets a Sc2 client from Sc2::ClientManager and connects them
    def connect_players
      # Depending on number of players, api has different ready states
      ready_statuses = (api_players.size > 1) ? [:launched] : %i[launched ready]

      # For each player, attempt to connect and retry once after closing Sc2 in worst-case
      api_players.each_with_index do |player, i|
        1.upto(max_retires = 2) do |attempt|
          Sc2.logger.debug { "Player(#{i}) Obtain client for: #{player.class}, #{player.name}" }
          client = ClientManager.obtain(i)
          sleep(8) if ENV["SC2PF"] == Paths::PF_WINDOWS
          Sc2.logger.debug { "Player(#{i}) Connect to client: #{client.host}:#{client.port}" }
          player.connect(host: client.host, port: client.port)
          Sc2.logger.debug { "Player(#{i}) Connected." }
          Sc2.logger.debug { "Player(#{i}) Status is: #{player.status}" }
          break if ready_statuses.include?(player.status)

          Sc2.logger.debug { "Player(#{i}) Attempt to leave game..." }
          player.leave_game
          break if ready_statuses.include?(player.status)

          raise Error, "Player(#{i}) Unable to get client" unless attempt < max_retires

          Sc2.logger.debug { "Player(#{i}) Leave failed. Retry by stopping client..." }
          player.disconnect
          ClientManager.stop(i)
          next
        end
      end
    end

    # Configure hooks
    def setup_player_hooks
      api_players.each do |player|
        # Clean surrender locally. Lapizistik taught me bad things.
        def player.leave_game
          debug_end_game(end_result: :Surrender)
        end
      end
    end

    # Returns a list of players which requires an Sc2 instance
    # @return [Array<Sc2::Player>] players which requires_client?
    def api_players
      players.select(&:requires_client?)
    end

    # Returns the first player which requires an Api connection as the host
    # @return [Sc2::Player] host
    def player_host
      raise Sc2::Error, "No host player found. API players are empty." if api_players.nil? || api_players.empty?
      # noinspection RubyMismatchedReturnType
      api_players.first
    end
  end
end
