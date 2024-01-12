# frozen_string_literal: true

module Sc2
  class Connection
    # Callbacks when game status changes
    module StatusListener
      # Called when game status changes
      # @param status [:launched, :in_game, :in_replay, :ended, :quit, :unknown] game state, i.e. :in_game, :ended, :launched
      # noinspection
      def on_status_change(status)
        Sc2.logger.debug { "#{self.class}.#{__method__} #{status}" }
      end
    end
  end
end
