# frozen_string_literal: true

module Sc2
  class Connection
    # Callbacks should be included on your listening class
    # noinspection RubyUnusedLocalVariable
    module ConnectionListener
      # Called when connection established to application
      # @param connection [Sc2Ai::Connection]
      # noinspection
      def on_connected(connection)
        Sc2.logger.debug { "#{self.class}.#{__method__} #{connection}" }
      end

      # Called while waiting on connection to application
      # @param connection [Sc2Ai::Connection]
      # noinspection Lint/UnusedMethodArgument
      def on_connection_waiting(connection)
        Sc2.logger.debug { "#{self.class}.#{__method__} #{connection}" }
      end

      # Called when disconnected from application
      # @param connection [Sc2Ai::Connection]
      # noinspection Lint/UnusedMethodArgument
      def on_disconnect(connection)
        Sc2.logger.debug { "#{self.class}.#{__method__} #{connection}" }
      end
    end
  end
end
