# frozen_string_literal: true

module Sc2
  class Player
    # WARNING! Debug methods will not be available on Ladder
    # This provides debug helper functions for RequestDebug
    module Debug
      # Holds debug commands which will be queued off each time we step forward
      # @!attribute debug_commands_queue
      #   @return [Array<Api::Action>]
      attr_accessor :debug_command_queue

      # Queues debug command for performing later
      # @param debug_command [Api::DebugCommand]
      # @return [void]
      def queue_debug_command(debug_command)
        @debug_command_queue << debug_command
      end

      # Draw Commands ---

      # Prints debug text top left corner
      # @param text [String] will respect newlines
      # @param size [Size] of font, default 14px
      # @return [void]
      def debug_print(text, size: 14)
        queue_debug_command Api::DebugCommand.new(
          draw: Api::DebugDraw.new(
            text: [
              Api::DebugText.new(
                text:,
                size:,
                virtual_pos: Api::Point.new(x: 0.01, y: 0.01) # unit or fixed position.
              )
            ]
          )
        )
      end

      # Draws a line between two Api::Point's for color
      # @param p0 [Api::Point] the first point
      # @param p1 [Api::Point] the second point
      # @param color [Api::Color] default white
      # @return [void]
      def debug_draw_line(p0:, p1:, color: nil)
        queue_debug_command Api::DebugCommand.new(
          draw: Api::DebugDraw.new(
            lines: [
              Api::DebugLine.new(
                color:,
                line: Api::Line.new(
                  p0:,
                  p1:
                )
              )
            ]
          )
        )
      end

      # Draws a box around position xy at base of z. Good for structure boxing.
      # @example
      #   # Draws a box on structure placement grid
      #   debug_draw_box(point: unit.pos, radius: unit.footprint_radius)
      #
      # @note Api::Color RGB is broken for this command. Will use min(r,b)
      # @note Z index is elevated 0.02 so the line is visible and doesn't clip through terrain
      # @param point [Api::Point]
      # @param radius [Float] default one tile wide, 1.0
      # @param color [Api::Color] default white. min(r,b) is used for both r&b
      # @return [void]
      def debug_draw_box(point:, radius: 0.5, color: nil)
        queue_debug_command Api::DebugCommand.new(
          draw: Api::DebugDraw.new(
            boxes: [
              Api::DebugBox.new(
                min: Api::Point.new(x: point.x - radius, y: point.y - radius, z: point.z + 0.01),
                max: Api::Point.new(x: point.x + radius, y: point.y + radius, z: point.z + (radius * 2) + 0.01),
                color:
              )
            ]
          )
        )
      end

      # Debug draws a sphere at position with a radius in color
      # @param point [Api::Point]
      # @param radius [Float] default one tile wide, 1.0
      # @param color [Api::Color] default white. min(r,b) is used for both r&b
      # @return [void]
      def debug_draw_sphere(point:, radius: 1.0, color: nil)
        queue_debug_command Api::DebugCommand.new(
          draw: Api::DebugDraw.new(
            spheres: [
              Api::DebugSphere.new(
                p: point,
                r: radius,
                color:
              )
            ]
          )
        )
      end

      # Other Commands ---

      # Toggles cheat commands on/off (send only once to enable)
      # @param command [Integer] one of Api::DebugGameState::*
      # Possible values:
      #  Api::DebugGameState::Show_map
      #  Api::DebugGameState::Control_enemy
      #  Api::DebugGameState::Food
      #  Api::DebugGameState::Free
      #  Api::DebugGameState::all_resources
      #  Api::DebugGameState::God
      #  Api::DebugGameState::Minerals
      #  Api::DebugGameState::Gas
      #  Api::DebugGameState::Cooldown
      #  Api::DebugGameState::Tech_tree
      #  Api::DebugGameState::Upgrade
      #  Api::DebugGameState::Fast_build
      # @return [void]
      def debug_game_state(command)
        queue_debug_command Api::DebugCommand.new(
          game_state: command
        )
      end

      # Spawns a quantity of units under an owner at position given
      # @param unit_type_id [Integer] Api::UnitTypeId::*
      # @param owner [Integer] typically you are 1 and 2 is enemy (see @common.player_id)
      # @param pos [Api::Point2D] position in 2d
      # @param quantity [Integer] default 1
      # @return [void]
      def debug_create_unit(unit_type_id:, owner:, pos:, quantity: 1)
        queue_debug_command Api::DebugCommand.new(
          create_unit: Api::DebugCreateUnit.new(
            unit_type: unit_type_id,
            owner:,
            pos:,
            quantity:
          )
        )
      end

      # Kills a target unit or unit tag
      # @param unit_tags [Integer, Array<Integer>] one or many unit tags to kill
      # @return [void]
      def debug_kill_unit(unit_tags:)
        unit_tags = [unit_tags] if unit_tags.is_a? Integer
        queue_debug_command Api::DebugCommand.new(
          kill_unit: Api::DebugKillUnit.new(
            tag: unit_tags
          )
        )
      end

      # @private
      # Hangs, crashes and exits the Sc2 client. DO NOT USE.
      # @param test [Integer] one of Api::DebugTestProcess::Test::Crash, Api::DebugTestProcess::Test::Hang, Api::DebugTestProcess::Test::Exit
      # @param delay_ms [Integer] default 0, how long this test is delayed
      # @return [void]
      def debug_test_process(test:, delay_ms: 0)
        queue_debug_command Api::DebugCommand.new(
          test_process: Api::DebugTestProcess.new(
            test:,
            delay_ms:
          )
        )
      end

      # @private
      # Useful only for single-player "curriculum" maps
      # @param score [Float] sets the score
      def debug_set_score(score: 0.0)
        queue_debug_command Api::DebugCommand.new(
          score: Api::DebugSetScore.new(
            score:
          )
        )
      end

      # Ends game with a specified result of either Surrender or DeclareVictory
      # @param end_result [Integer] either 1/2.  Api::DebugEndGame::EndResult::Surrender or Api::DebugEndGame::EndResult::DeclareVictory
      # @return [void]
      def debug_end_game(end_result:)
        queue_debug_command Api::DebugCommand.new(
          end_game: Api::DebugEndGame.new(
            end_result:
          )
        )
      end

      # Sets unit_value Energy, Life or Shields for a specific unit tag to given value
      # @param unit_tag [Integer]
      # @param unit_value [Integer] 1=Energy,2=Life,3=Shields one of Api::DebugSetUnitValue::UnitValue::*
      # @param value [Float] the value which the attribute will be set to
      # @return [void]
      def debug_set_unit_value(unit_tag:, unit_value:, value:)
        queue_debug_command Api::DebugCommand.new(
          unit_value: Api::DebugSetUnitValue.new(
            unit_tag:,
            unit_value:, # property
            value: # value
          )
        )
      end

      private

      # Sends actions via api and flushes debug_commands_queue
      def perform_debug_commands
        @api.debug(@debug_command_queue) unless @debug_command_queue.empty?
        clear_debug_command_queue
      end

      # Empties and resets @debug_queue
      # @return [void]
      def clear_debug_command_queue
        @debug_command_queue = []
      end
    end
  end
end
