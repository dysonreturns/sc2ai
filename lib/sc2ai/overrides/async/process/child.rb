# Overrides process spawn for windows pgroup

require "async/process"

module Async
  module Process
    class Child
      def initialize(*args, **options)
        # Setup a cross-thread notification pipe - nio4r can't monitor pids unfortunately:
        pipe = ::IO.pipe
        @input = Async::IO::Generic.new(pipe.first)
        @output = pipe.last

        @exit_status = nil

        if Gem.win_platform?
          options[:new_pgroup] = true
        else
          options[:pgroup] = true
        end

        @pid = ::Process.spawn(*args, **options)

        @thread = Thread.new do
          _, @exit_status = ::Process.wait2(@pid)
          @output.close
        end
      end
    end
  end
end