# frozen_string_literal: true

# @private
# Patched from: rails/activesupport/lib/active_support/core_ext/kernel/reporting.rb
# https://github.com/rails/rails/blob/04972d9b9ef60796dc8f0917817b5392d61fcf09/activesupport/lib/active_support/core_ext/kernel/reporting.rb#L26
module Kernel
  module_function

  # Sets $VERBOSE to +nil+ for the duration of the block and back to its original
  # value afterwards.
  #
  #   silence_warnings do
  #     value = noisy_call # no warning voiced
  #   end
  #
  #   noisy_call # warning voiced
  def silence_warnings(&)
    with_warnings(nil, &)
  end

  # Sets $VERBOSE for the duration of the block and back to its original
  # value afterwards.
  # noinspection RubyGlobalVariableNamingConvention
  def with_warnings(flag)
    old_verbose = $VERBOSE
    $VERBOSE = flag
    yield
  ensure
    $VERBOSE = old_verbose
  end
end
