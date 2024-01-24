module Api
  # Adds additional functionality to message object Api::PowerSource
  module PowerSourceExtension
    include Sc2::Position

    # Adds additional functionality to message class Api::PowerSource
    module ClassMethods
      # Shorthand for creating an instance for [x, y, z]
      # @example
      #   Api::Point[1,2,3] # Where x is 1.0, y is 2.0 and z is 3.0
      # @return [Api::Point]
      def [](x, y, z)
        Api::Point.new(x: x, y: y, z: z)
      end
    end
  end
end
Api::PowerSource.include Api::PowerSourceExtension
Api::PowerSource.extend Api::PowerSourceExtension::ClassMethods
