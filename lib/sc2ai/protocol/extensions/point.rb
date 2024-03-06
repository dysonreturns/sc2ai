module Api
  # Adds additional functionality to message object Api::Point
  module PointExtension
    # Creates a Point2D using x and y
    # @return [Api::Point2D]
    def to_p2d
      Api::Point2D.new(x: x, y: y)
    end

    # Adds additional functionality to message class Api::Point
    module ClassMethods
      # Shorthand for creating an instance for [x, y, z]
      # @example
      #   Api::Point[1,2,3] # Where x is 1.0, y is 2.0 and z is 3.0
      # @return [Api::Point]
      # @param [Float] x
      # @param [Float] y
      # @param [Float] z
      def [](x, y, z)
        Api::Point.new(x: x, y: y, z: z)
      end
    end
  end
end
Api::Point.include Api::PointExtension
Api::Point.extend Api::PointExtension::ClassMethods
