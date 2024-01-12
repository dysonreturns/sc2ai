# This class was partially generated with the help of AI.

module Api
  # Adds additional functionality to message object Api::Point2D
  module Point2DExtension
    def self.included(base)
      super(base)
      base.extend ClassMethods
    end

    def hash
      [x, y].hash
    end

    def eql?(other)
      # This is faster, but intolerant. Consider changing to method below it
      self.class == other.class && hash == other.hash
      # self.class == other.class && ((x - other.x).abs < TOLERANCE) && ((y - other.y).abs < TOLERANCE)
    end

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
