module Api
  # Adds additional functionality to message object Api::Point2D
  module Point2DExtension
    # @private
    def hash
      [x, y].hash
    end

    def eql?(other)
      self.class == other.class && hash == other.hash
    end

    # Create a new 3d Point, by adding a y axis.
    # @return [Api::Point]
    def to_3d(z:)
      Api::Point[x, y, z]
    end

    # Adds additional functionality to message class Api::Point2D
    module ClassMethods
      # Shorthand for creating an instance for [x, y]
      # @example
      #   Api::Point2D[2,4] # Where x is 2.0 and y is 4.0
      # @return [Api::Point2D]
      def [](x, y)
        Api::Point2D.new(x: x, y: y)
      end
    end
  end
end
Api::Point2D.include Api::Point2DExtension
Api::Point2D.extend Api::Point2DExtension::ClassMethods
