# frozen_string_literal: true

module Sc2
  class Connection
    # Sends protobuf requests over Connection to Client
    module Requests
      # GAME MANAGEMENT ----

      # Send to host to initialize game
      def create_game(map:, players:, realtime: false)
        send_request_for create_game: Api::RequestCreateGame.new(
          local_map: Api::LocalMap.new(map_path: map.path),
          player_setup: players.map do |player|
            Api::PlayerSetup.new(
              type: player.type,
              race: player.race,
              player_name: player.name,
              difficulty: player.difficulty,
              ai_build: player.ai_build
            )
          end,
          realtime:
        )
      end

      # Send to host and all clients for game to begin.
      def join_game(race:, name:, server_host:, port_config:, enable_feature_layer: false, interface_options: {})
        interface_options ||= {}

        default_crop_playable_area = true
        default_raw_affects_selection = false

        # TODO: if is_live? # perform these actions only LIVE
        #   default_raw_affects_selection = true
        #   default_crop_playable_area = true

        send_request_for join_game: Api::RequestJoinGame.new(
          # TODO: For Observer support, get player_index for observer,
          #   don't set race and pass observed_player_id: player_index
          # observed_player_id: 0, # For observer
          # --
          race:,
          player_name: name,
          host_ip: server_host,
          server_ports: port_config.server_port_set,
          client_ports: port_config.client_port_sets,
          options: Api::InterfaceOptions.new(
            {
              raw: true,
              score: false,
              feature_layer: feature_layer_interface_options(enable_feature_layer),
              show_cloaked: true,
              show_burrowed_shadows: true,
              show_placeholders: true,
              raw_affects_selection: default_raw_affects_selection,
              raw_crop_to_playable_area: default_crop_playable_area
            }.merge!(interface_options)
          )
        )
      end

      # @private
      # Default options for feature layer, which enables it,
      # but sets the map/minimap size to 1x1 for peak performance.
      # A user can manually pass in it's own interface options
      def feature_layer_interface_options(enabled)
        return nil unless enabled

        ::Api::SpatialCameraSetup.new(
          width: 1.0,
          resolution: Api::Size2DI.new(x: 1, y: 1),
          minimap_resolution: Api::Size2DI.new(x: 1, y: 1),
          # width: 10.0,
          # resolution: Api::Size2DI.new(x: 128, y: 128),
          # minimap_resolution: Api::Size2DI.new(x: 16, y: 16),
          crop_to_playable_area: true, # has no effect. minimap x and y are respected no matter what
          allow_cheating_layers: false
        )
      end

      protected :feature_layer_interface_options

      # Single player only. Reinitializes the game with the same player setup.
      def restart_game
        send_request_for restart_game: Api::RequestRestartGame.new
      end

      # Given a replay file path or replay file contents, will start the replay
      # @example
      #   Sc2.config do |config|
      #     config.version = "4.10"
      #   end
      #   Async do
      #     client = Sc2::ClientManager.obtain(0)
      #     observer = Sc2::Player::Observer.new
      #     observer.connect(host: client.host, port: client.port)
      #     pp observer.api.start_replay(
      #       replay_path: Pathname("./data/replays/test.SC2Replay").realpath
      #     )
      #     while observer.status == :in_replay
      #       #   Step forward
      #       observer.api.step(1)
      #       #   fresh observation info
      #       observation = observer.api.observation
      #       #   fresh game info
      #       game_info = observer.api.game_info
      #     end
      #   ensure
      #     Sc2::ClientManager.stop(0)
      #   end
      # @param replay_path [String] path to replay
      # @param replay_data [String] alternative to file, binary string of replay_file.read
      # @param map_data [String] optional binary string of SC2 map if not present in paths
      # @param options [Hash] Api:RequestStartReplay options, such as disable_fog, observed_player_id, map_data
      # @param [Hash] interface_options
      def start_replay(replay_path: nil, replay_data: nil, map_data: nil, record_replay: true, interface_options: {}, **options)
        raise Sc2::Error, "Missing replay." if replay_data.nil? && replay_path.nil?

        interface_options ||= {}
        send_request_for start_replay: Api::RequestStartReplay.new(
          {
            replay_path: replay_path.to_s,
            replay_data: replay_data,
            map_data: map_data,
            realtime: false,
            disable_fog: true,
            record_replay: record_replay,
            observed_player_id: 0,
            options: Api::InterfaceOptions.new(
              {
                raw: true,
                score: true,
                feature_layer: feature_layer_interface_options(true),
                show_cloaked: true,
                show_burrowed_shadows: true,
                show_placeholders: true,
                raw_affects_selection: false,
                raw_crop_to_playable_area: true
              }.merge!(interface_options)
            )
          }.merge(options)
        )
      end

      # Multiplayer only. Disconnects from a multiplayer game, equivalent to surrender. Keeps client alive.
      def leave_game
        send_request_for leave_game: Api::RequestLeaveGame.new
      end

      # Saves game to an in-memory bookmark.
      def request_quick_save
        send_request_for quick_save: Api::RequestQuickSave.new
      end

      # Loads from an in-memory bookmark.
      def request_quick_load
        send_request_for quick_load: Api::RequestQuickLoad.new
      end

      # Quits Sc2. Does not work on ladder.
      def quit
        send_request_for quit: Api::RequestQuit.new
      end

      # DURING GAME -

      # // During Game

      # Static data about the current game and map.
      # @return [Api::ResponseGameInfo]
      def game_info
        send_request_for game_info: Api::RequestGameInfo.new
      end

      # Data about different gameplay elements. May be different for different games.
      # Note that buff_id and effect_id gives worse quality data than generated from stableids (EffectId and BuffId)
      # Those options are disabled by default
      # @param ability_id [Boolean] to include ability data
      # @param unit_type_id [Boolean] to include unit data
      # @param upgrade_id [Boolean] to include upgrade data
      # @param buff_id [Boolean] to get include buff data
      # @param effect_id [Boolean] to get to include effect data
      # @return [Api::ResponseData]
      def data(ability_id: true, unit_type_id: true, upgrade_id: true, buff_id: true, effect_id: true)
        send_request_for data: Api::RequestData.new(
          ability_id:,
          unit_type_id:,
          upgrade_id:,
          buff_id:,
          effect_id:
        )
      end

      # Snapshot of the current game state. Primary source for raw information
      # @param game_loop [Integer] you wish to wait for (realtime only)
      def observation(game_loop: nil)
        # Sc2.logger.debug { "#{self.class}.#{__method__} game_loop: #{game_loop}" }
        if game_loop.nil?
          # Uncomment to enable multiple gc
          # Async do
          #   result = Async do

          @_cached_request_observation ||= Api::Request.new(
            observation: Api::RequestObservation.new
          ).to_proto
          @websocket.send_binary(@_cached_request_observation)
          response = Api::Response.decode(@websocket.read.to_str)

          if @status != response.status
            @status = response.status
            @listeners[StatusListener.name]&.each { _1.on_status_change(@status) }
          end

          response.observation

          # Uncomment to enable manual GC
          # end

          #   Async do
          #     # A step command is synchronous for both bots.
          #     # Bot A will wait for Bot B, then both get responses.
          #     # If we're ahead or even not, we can perform a minor GC sweep while we wait.
          #     # If the server notifies the other machine first
          #     # This smooths out unexpected hiccups and reduces overall major gc sweeps, possibly for free.
          #     begin
          #       GC.start(full_mark: false, immediate_sweep: true)
          #       # if rand(100).zero? # Just below every 5 seconds
          #       #   GC.compact
          #       # end
          #     rescue
          #       # noop - just here for cleaner exceptions on interrupt
          #     end
          #   end
          #   result.wait
          # end.wait

        else
          send_request_for observation: Api::RequestObservation.new(game_loop:)
        end
      end

      # Executes an array of [Api::Action] for a participant
      # @param actions [Array<Api::Action>] to perform
      # @return [Api::ResponseAction]
      def action(actions)
        send_request_for action: Api::RequestAction.new(
          actions: actions
        )
      end

      # Executes an actions for an observer.
      # @param actions [Array<Api::ObserverAction>]
      def observer_action(actions)
        # ActionObserverCameraMove camera_move = 2;
        # ActionObserverCameraFollowPlayer camera_follow_player = 3;
        send_request_for obs_action: Api::RequestObserverAction.new(
          actions: actions
        )
      end

      # Moves observer camera to a position at a distance
      # @param world_pos [Api::Point2D]
      # @param distance [Float] Distance between camera and terrain. Larger value zooms out camera. Defaults to standard camera distance if set to 0.
      def observer_action_camera_move(world_pos, distance = 0)
        observer_action([Api::ObserverAction.new(
          camera_move: Api::ActionObserverCameraMove.new(
            world_pos:,
            distance:
          )
        )])
      end

      # Advances the game simulation by step_count. Not used in realtime mode.
      # Only constant step size supported - subsequent requests use cache.
      def step(step_count = 1)
        # if step_count == @_last_step_count
        @_cached_request_step ||= Api::Request.new(
          step: Api::RequestStep.new(count: step_count)
        ).to_proto
        send_request_and_ignore(@_cached_request_step)
      end

      # Additional methods for inspecting game state. Synchronous and must wait on response
      # @param pathing [Array<Api::RequestQueryPathing>]
      # @param abilities [Array<Api::RequestQueryAvailableAbilities>]
      # @param placements [Array<Api::RequestQueryBuildingPlacement>]
      # @param ignore_resource_requirements [Boolean] Ignores requirements like food, minerals and so on.
      # @return [Api::ResponseQuery]
      def query(pathing: nil, abilities: nil, placements: nil, ignore_resource_requirements: true)
        send_request_for query: Api::RequestQuery.new(
          pathing:,
          abilities:,
          placements:,
          ignore_resource_requirements:
        )
      end

      # Queries one or more pathing queries
      # @param queries [Array<Api::RequestQueryPathing>, Api::RequestQueryPathing] one or more pathing queries
      # @return [Array<Api::ResponseQueryPathing>, Api::ResponseQueryPathing] one or more results depending on input size
      def query_pathings(queries)
        arr_queries = queries.is_a?(Array) ? queries : [queries]

        response = send_request_for query: Api::RequestQuery.new(
          pathing: arr_queries
        )
        (arr_queries.size > 1) ? response.pathing : response.pathing.first
      end

      # Queries one or more ability-available checks
      # @param queries [Array<Api::RequestQueryAvailableAbilities>, Api::RequestQueryAvailableAbilities] one or more pathing queries
      # @param ignore_resource_requirements [Boolean] Ignores requirements like food, minerals and so on.
      # @return [Array<Api::ResponseQueryAvailableAbilities>, Api::ResponseQueryAvailableAbilities] one or more results depending on input size
      def query_abilities(queries, ignore_resource_requirements: true)
        arr_queries = queries.is_a?(Array) ? queries : [queries]

        response = send_request_for query: Api::RequestQuery.new(
          abilities: arr_queries,
          ignore_resource_requirements:
        )
        (arr_queries.size > 1) ? response.abilities : response.abilities.first
      end

      # Queries available abilities for units
      # @param unit_tags [Array<Integer>, Integer] an array of unit tags or a single tag
      # @param ignore_resource_requirements [Boolean] Ignores requirements like food, minerals and so on.
      # @return [Array<Api::ResponseQueryAvailableAbilities>, Api::ResponseQueryAvailableAbilities] one or more results depending on input size
      def query_abilities_for_unit_tags(unit_tags, ignore_resource_requirements: true)
        queries = []
        unit_tags = [unit_tags] unless unit_tags.is_a? Array
        unit_tags.each do |unit_tag|
          queries << Api::RequestQueryAvailableAbilities.new(unit_tag: unit_tag)
        end

        query_abilities(queries, ignore_resource_requirements:)
      end

      # Queries one or more pathing queries
      # @param queries [Array<Api::RequestQueryBuildingPlacement>, Api::RequestQueryBuildingPlacement] one or more placement queries
      # @return [Array<Api::ResponseQueryBuildingPlacement>, Api::ResponseQueryBuildingPlacement] one or more results depending on input size
      def query_placements(queries)
        arr_queries = queries.is_a?(Array) ? queries : [queries]

        response = query(placements: arr_queries)

        (arr_queries.size > 1) ? response.placements : response.placements.first
      end

      # Generates a replay.
      def save_replay
        send_request_for save_replay: Api::RequestSaveReplay.new
      end

      # MapCommand does not actually gracefully trigger start/restart
      # RequestMapCommand map_command = 22;         // Execute a particular trigger through a string interface

      # Returns metadata about a replay file. Does not load the replay.
      # RequestReplayInfo replay_info = 16;         //
      # @param replay_path [String] path to replay
      # @param replay_data [String] alternative to file, binary string of replay_file.read
      # @param download_data [String] if true, ensure the data and binary are downloaded if this is an old version replay.
      # @return [Api::ResponseReplayInfo]
      def replay_info(replay_path: nil, replay_data: nil, download_data: false)
        raise Sc2::Error, "Missing replay." if replay_data.nil? && replay_path.nil?

        send_request_for replay_info: Api::RequestReplayInfo.new(
          replay_path: replay_path.to_s,
          replay_data: replay_data,
          download_data: download_data
        )
      end

      # Returns directory of maps that can be played on.
      # @return [Api::ResponseAvailableMaps] which has #local_map_paths and #battlenet_map_names arrays
      def available_maps
        send_request_for available_maps: Api::RequestAvailableMaps.new
      end

      # Saves binary map data to the local temp directory.
      def save_map
        send_request_for save_map: Api::RequestSaveMap.new
      end

      # Network ping for testing connection.
      def ping
        send_request_for ping: Api::RequestPing.new
      end

      # Display debug information and execute debug actions
      # @param commands [Array<Api::DebugCommand>]
      # @return [void]
      def debug(commands)
        send_request_for debug: Api::RequestDebug.new(
          debug: commands
        )
      end

      # Sends request for type and returns response that type, i.e.
      #    send_request_for(observation: RequestObservation)
      # Is identical to
      #    send_request(
      #      Api::Request.new(observation: RequestObservation)
      #    )[:observation]
      def send_request_for(**kwargs)
        response = send_request(Api::Request.new(kwargs))
        response[kwargs.keys.first.to_s]
      end

      private
    end
  end
end
