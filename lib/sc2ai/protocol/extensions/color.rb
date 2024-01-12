module Api
  # Adds additional functionality and fixes quirks with color specifically pertaining to debug commands
  module ColorExtension
    def self.included(base)
      super(base)
      base.extend ClassMethods
    end

    # For lines: r & b are swapped.
    def initialize(r:, g:, b:)
      super(r: b, g: g, b: r)
    end

    module ClassMethods
      # Creates a new Api::Color object with random rgb values
      # @return [Api::Color] random color
      def random
        Api::Color.new(r: rand(0..255), g: rand(0..255), b: rand(0..255))
      end
    end
  end
end
Api::Color.include Api::ColorExtension
