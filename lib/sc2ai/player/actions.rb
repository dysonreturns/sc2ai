module Sc2
  class Player
    # Holds action list and queues batch
    module Actions
      # Holds actions which will be queued off each time we step forward
      # @!attribute action_queue
      #   @return [Array<Api::Action>]
      attr_accessor :action_queue

      # Queues action for performing later
      # @param action [Api::Action]
      # @return [void]
      def queue_action(action)
        @action_queue << action
      end

      # Queues a Api::ActionRaw. Perform ability on unit_tags optionally on target_world_space_pos/target_unit_tag
      # @param unit_tags [Array<Integer>]
      # @param ability_id [Integer]
      # @param queue_command [Boolean] Shift+Click, default: false
      # @param target_world_space_pos [Api::Point2D]
      # @param target_unit_tag [Integer]
      def action_raw_unit_command(unit_tags:, ability_id:, queue_command: false, target_world_space_pos: nil, target_unit_tag: nil)
        queue_action Api::Action.new(
          action_raw: Api::ActionRaw.new(
            unit_command: Api::ActionRawUnitCommand.new(
              unit_tags: unit_tags,
              ability_id: ability_id,
              queue_command: queue_command,
              target_world_space_pos: target_world_space_pos,
              target_unit_tag: target_unit_tag
            )
          )
        )
      end

      # Queues a Api::ActionRawUnitCommand.
      # Send accepts a Api::Unit, tag or tags and targets Api::Point2D or unit.tag
      # @param units [Array<Integer>,Integer,Api::Unit] can be an Api::Unit, array of Api::Unit#tag or single tag
      # @param ability_id [Integer]
      # @param target [Api::Unit, Integer, Api::Point2D] is a unit, unit tag or a Api::Point2D
      # @param queue_command [Boolean] Shift+Click, default: false
      def action(units:, ability_id:, target: nil, queue_command: false)
        unit_tags = unit_tags_from_source(units)

        target_pos = nil
        target_unit_tag = nil
        if target.is_a? Api::Point2D
          target_pos = target
        elsif target.is_a? Api::Unit
          target_unit_tag = target.tag
        else
          target_unit_tag = target
        end

        # noinspection RubyMismatchedArgumentType
        action_raw_unit_command(
          unit_tags: unit_tags,
          ability_id: ability_id,
          queue_command: queue_command,
          target_world_space_pos: target_pos,
          target_unit_tag: target_unit_tag
        )
      end

      # Builds target unit type using units as source at optional target
      # @param unit_type_id [Integer] Api::UnitTypeId the unit type which will do the creation
      # @param target [Api::Point2D, Integer, nil] is a unit tag or a Api::Point2D. Nil for addons/orbital
      # @param queue_command [Boolean] shift+command
      def build(units:, unit_type_id:, target: nil, queue_command: false)
        # Get build ability from target building type
        action(units:,
          ability_id: unit_data(unit_type_id).ability_id,
          target:,
          queue_command:)
        subtract_cost(unit_type_id)
      end

      # Warps in unit type at target (location or pylon) with optional source units (warp gates)
      # When not specifying the specific warp gate(s), all warpgates will be used
      # @param unit_type_id [Integer] Api::UnitTypeId the unit type which will do the creation
      # @param target [Api::Point2D, Integer] is a unit tag or a Api::Point2D
      def warp(unit_type_id:, target:, queue_command:, units: nil)
        warp_ability = Api::TechTree.unit_type_creation_abilities(
          source: Api::UnitTypeId::WARPGATE,
          target: unit_type_id
        )
        units = structures.warpgates if units.nil?
        action(units: units,
          ability_id: warp_ability[:ability],
          target:,
          queue_command:)
        subtract_cost(unit_type_id)
      end

      # Toggles auto-cast ability for units
      # @param units [Array<Integer>, Integer, Api::Unit] can be an Api::Unit, array of Tags or single Tag
      # @param ability_id [Integer]
      # @return [void]
      def action_raw_toggle_autocast(units:, ability_id:)
        unit_tags = unit_tags_from_source(units)
        queue_action Api::Action.new(
          action_raw: Api::ActionRaw.new(
            toggle_autocast: Api::ActionRawToggleAutocast.new(
              ability_id: ability_id,
              unit_tags: unit_tags
            )
          )
        )
      end

      # Toggles auto-cast ability for units
      # @param point [Api::Point]
      # @return [void]
      def action_raw_camera_move(point:)
        queue_action Api::Action.new(
          action_raw: Api::ActionRaw.new(
            camera_move: Api::ActionRawCameraMove.new(
              center_world_space: point
            )
          )
        )
      end

      # ActionSpatial - Feature layer --------

      # Issues spatial unit command. Target is either target_screen_coord or target_minimap_coord.
      # @param ability_id [Api::AbilityId]
      # @param target_screen_coord [Api::Point2I]
      # @param target_minimap_coord [Api::Point2I]
      # @param queue_command [Boolean] Shift+Click, default: false
      # @return [void]
      def action_spatial_unit_command(ability_id:, target_screen_coord: nil, target_minimap_coord: nil, queue_command: false)
        queue_action Api::Action.new(
          action_raw: Api::ActionSpatial.new(
            unit_command: Api::ActionSpatialUnitCommand.new(
              ability_id: ability_id,
              target_screen_coord: target_screen_coord,
              target_minimap_coord: target_minimap_coord,
              queue_command: queue_command
            )
          )
        )
      end

      # Simulates a click on the minimap to move the camera.
      # @param center_minimap [Api::Point2I]
      # @return [void]
      #
      def action_spatial_camera_move(center_minimap:)
        queue_action Api::Action.new(
          action_feature_layer: Api::ActionSpatial.new(
            camera_move: Api::ActionSpatialCameraMove.new(
              center_minimap: center_minimap
            )
          )
        )
      end

      # Issues spatial unit select point command. Target is either target_screen_coord or target_minimap_coord.
      # @param type [Integer] 1,2,3,4 = Api::ActionSpatialUnitSelectionPoint::Type::*
      #   enum Type {
      #     Select = 1;         // Equivalent to normal click. Changes selection to unit.
      #     Toggle = 2;         // Equivalent to shift+click. Toggle selection of unit.
      #     AllType = 3;        // Equivalent to control+click. Selects all units of a given type.
      #     AddAllType = 4;     // Equivalent to shift+control+click. Selects all units of a given type.
      #   }
      # @param selection_screen_coord [Api::PointI]
      # @return [void]
      def action_spatial_unit_selection_point(type: Api::ActionSpatialUnitSelectionPoint::Type::Select, selection_screen_coord: nil)
        queue_action Api::Action.new(
          action_feature_layer: Api::ActionSpatial.new(
            unit_selection_point: Api::ActionSpatialUnitSelectionPoint.new(
              type: type,
              selection_screen_coord: selection_screen_coord
            )
          )
        )
      end

      # Issue rectangle select
      # @param selection_screen_coord [Api::RectangleI] rectangle coordinates
      # @param selection_add [Boolean] default false Equivalent to shift+drag. Adds units to selection. default false
      # @return [void]
      def action_spatial_unit_selection_rect(selection_screen_coord:, selection_add: false)
        queue_action Api::Action.new(
          action_feature_layer: Api::ActionSpatial.new(
            unit_selection_rect: Api::ActionSpatialUnitSelectionRect.new(
              selection_screen_coord: selection_screen_coord,
              selection_add: selection_add
            )
          )
        )
      end

      # ActionUI - Feature layer --------

      # Perform action on control group like setting or recalling, use in conjunction with unit selection.
      # Populated if Feature Layer or Render interface is enabled.
      # @param action [Integer] 1-5 = Api::ActionControlGroup::ControlGroupAction::*
      #   enum ControlGroupAction {
      #     Recall = 1;             // Equivalent to number hotkey. Replaces current selection with control group.
      #     Set = 2;                // Equivalent to Control + number hotkey. Sets control group to current selection.
      #     Append = 3;             // Equivalent to Shift + number hotkey. Adds current selection into control group.
      #     SetAndSteal = 4;        // Equivalent to Control + Alt + number hotkey. Sets control group to current selection. Units are removed from other control groups.
      #     AppendAndSteal = 5;     // Equivalent to Shift + Alt + number hotkey. Adds current selection into control group. Units are removed from other control groups.
      #   }
      # @param control_group_index [Integer] 0-9
      # @return [void]
      def action_ui_control_group(action:, control_group_index:)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            control_group: Api::ActionControlGroup.new(
              action: action,
              control_group_index: control_group_index
            )
          )
        )
      end

      # Selects army (F2)
      # @param selection_add [Boolean] default false To add to other selected items
      # @return [void]
      def action_ui_select_army(selection_add: false)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            select_army: Api::ActionSelectArmy.new(
              selection_add: selection_add
            )
          )
        )
      end

      # Selects warp gates (Protoss)
      # @param selection_add [Boolean] default false To add to other selected items
      # @return [void]
      def action_ui_select_warp_gates(selection_add: false)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            select_warp_gates: Api::ActionSelectWarpGates.new(
              selection_add: selection_add
            )
          )
        )
      end

      # Selects larva (Zerg)
      # @return [void]
      def action_ui_select_larva
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            select_larva: Api::ActionSelectLarva.new
          )
        )
      end

      # Select idle workers
      # @param type [Integer] 1-4 = Api::ActionSelectIdleWorker::Type::*
      #
      #   enum Type {
      #     Set = 1;        // Equivalent to click with no modifiers. Replaces selection with single idle worker.
      #     Add = 2;        // Equivalent to shift+click. Adds single idle worker to current selection.
      #     All = 3;        // Equivalent to control+click. Selects all idle workers.
      #     AddAll = 4;     // Equivalent to shift+control+click. Adds all idle workers to current selection.
      #   }
      def action_ui_select_idle_worker(type:)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            select_idle_worker: Api::ActionSelectIdleWorker.new(
              type: type
            )
          )
        )
      end

      # Multi-panel actions for select/deselect
      # @param type [Integer] 1-4 = Api::ActionMultiPanel::Type::*
      # @param unit_index [Integer] n'th unit on panel
      #   enum Type {
      #     SingleSelect = 1;         // Click on icon
      #     DeselectUnit = 2;         // Shift Click on icon
      #     SelectAllOfType = 3;      // Control Click on icon.
      #     DeselectAllOfType = 4;    // Control+Shift Click on icon.
      #   }
      # message ActionMultiPanel {
      #   optional Type type = 1;
      #   optional int32 unit_index = 2;
      # }
      def action_ui_multi_panel(type:, unit_index:)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            multi_panel: Api::ActionMultiPanel.new(
              type: type,
              unit_index: unit_index
            )
          )
        )
      end

      # Cargo panel actions for unloading units.
      # @param unit_index [Integer] index of unit to unload
      def action_ui_cargo_panel_unload(unit_index:)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            cargo_panel: Api::ActionCargoPanelUnload.new(
              unit_index: unit_index
            )
          )
        )
      end

      # Remove unit from production queue
      # @param unit_index [Integer] target unit index
      def action_ui_production_panel_remove_from_queue(unit_index:)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            production_panel: Api::ActionProductionPanelRemoveFromQueue.new(
              unit_index: unit_index
            )
          )
        )
      end

      # Toggle autocast on selected unit. Also possible with raw actions using a unit target.
      # @param ability_id [Integer] Api::AbilityId::* ability
      def action_ui_toggle_autocast(ability_id:)
        queue_action Api::Action.new(
          action_ui: Api::ActionUI.new(
            toggle_autocast: Api::ActionToggleAutocast.new(
              unit_index: ability_id
            )
          )
        )
      end

      # Generic --------

      # Send a chat message
      # @param message [String] to send
      # @param channel [Integer] 1-2, default:Team  Api::ActionChat::Channel::Broadcast = 1, Api::ActionChat::Channel::Team = 2
      def action_chat(message, channel: Api::ActionChat::Channel::Team)
        queue_action Api::Action.new(
          action_chat: Api::ActionChat.new(
            channel: channel,
            message: message.to_s
          )
        )
      end

      private

      # Sends actions via api and flushes action_queue
      def perform_actions
        # request_actions = []
        # @action_queue.each do |queue_type, actions|
        #   request_actions.push(actions)
        # end

        @api.action(@action_queue) unless @action_queue.empty?
        clear_action_queue
      end

      # Empties and resets @action_queue
      # @return [void]
      def clear_action_queue
        @action_queue = []
        # TYPES.each do |type|
        #   @action_queue[type] = []
        # end
      end

      # Returns an array of unit tags from a variety of sources
      # @param source [Integer, Array<Integer>, Api::Unit, Sc2::UnitGroup] unit tag, tags, unit or unit group
      # @return [Array<Integer>] unit tag array
      # noinspection RubyMismatchedReturnType
      def unit_tags_from_source(source)
        return [] if source.nil?
        return [source.tag] if source.is_a? Api::Unit
        return source.tags if source.is_a? Sc2::UnitGroup
        return [source] unless source.is_a? Array

        source
      end
    end
  end
end
