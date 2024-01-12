# frozen_string_literal: true

require "socket"

RSpec.configure do |config|
  config.before do
    # stop socket binds
    allow_any_instance_of(Socket).to receive(:bind).and_return(:void)
    # Do NOT actually launch Sc2 during testing
    allow(Async::Process).to receive(:spawn).and_return(:void)
  end
end
