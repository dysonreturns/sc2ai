module Sc2
  # A unified construct that tames Api::* messages which contain location data
  # Items which are of type Sc2::Location will have #x and #y property at the least.
  module Position
    # Tolerance for floating-point comparisons.
    TOLERANCE = 1e-9

    # Basic operations

    # A new point representing the sum of this point and the other point.
    # @param other [Api::Point2D, Numeric] The other point/number to add.
    # @return [Api::Point2D]
    def add(other)
      if other.is_a? Numeric
        Api::Point2D[x + other, y + other]
      else
        Api::Point2D[x + other.x, y + other.y]
      end
    end
    alias_method :+, :add

    # Returns a new point representing the difference between this point and the other point/number.
    # @param other [Api::Point2D, Numeric] The other to subtract.
    # @return [Api::Point2D]
    def subtract(other)
      if other.is_a? Numeric
        Api::Point2D[x - other, y - other]
      else
        Api::Point2D[x - other.x, y - other.y]
      end
    end
    alias_method :-, :subtract

    # Returns this point multiplied by the scalar
    # @param scalar [Float] The scalar to multiply by.
    # @return [Api::Point2D]
    def multiply(scalar)
      Api::Point2D[x * scalar, y * scalar]
    end
    # @see #divide
    alias_method :*, :multiply

    # @param scalar [Float] The scalar to divide by.
    # @return [Api::Point2D] A new point representing this point divided by the scalar.
    # @raise [ZeroDivisionError] if the scalar is zero.
    def divide(scalar)
      raise ZeroDivisionError if scalar.zero?
      Api::Point2D[x / scalar, y / scalar]
    end
    # @see #divide
    alias_method :/, :divide

    # Bug: Psych implements method 'y' on Kernel, but protobuf uses method_missing to read AbstractMethod
    # We send method missing ourselves when y to fix this chain.
    def y
      # This is correct, but an unnecessary conditional:
      # raise NoMethodError unless location == self
      send(:method_missing, :y)
    end

    # Randomly adjusts both x and y by a range of: -offset..offset
    # @param offset [Float]
    # @return [Api::Point2D]
    def random_offset(offset)
      Api::Point2D.new[x, y].random_offset!(offset)
    end

    # Changes this point's x and y by the supplied offset
    # @return [Sc2::Position] self
    def random_offset!(offset)
      offset = offset.to_f
      range = rand(-offset..offset)
      offset!(rand(range), rand(range))
      self
    end

    # Creates a new point with x and y which is offset
    # @return [Api::Point2D] self
    def offset(x, y)
      Api::Point2D.new[x, y].offset!(x, y)
      self
    end

    # Changes this point's x and y by the supplied offset
    # @return [Sc2::Position] self
    def offset!(x, y)
      self.x -= x
      self.y -= y
      self
    end

    # Vector operations ---

    # For vector returns the magnitude, synonymous with Math.hypot
    # @return [Float]
    def magnitude
      Math.hypot(x, y)
    end

    # The dot product of this vector and the other vector.
    # @param other [Api::Point2D] The other vector to calculate the dot product with.
    # @return [Float]
    def dot(other)
      x * other.x + y * other.y
    end

    # The cross product of this vector and the other vector.
    # @param other [Api::Point2D] The other vector to calculate the cross product with.
    # @return [Float]
    def cross_product(other)
      x * other.y - y * other.x
    end

    # The angle between this vector and the other vector, in radians.
    # @param other [Api::Point2D] The other vector to calculate the angle to.
    # @return [Float]
    def angle_to(other)
      Math.acos(dot(other) / (magnitude * other.magnitude))
    end

    # A new point representing the normalized version of this vector (unit length).
    # @return [Api::Point2D]
    def normalize
      divide(magnitude)
    end

    # Other methods ---

    # Linear interpolation between this point and another for scale
    # Finds a point on a line between two points at % along the way. 0.0 returns self,  1.0 returns other, 0.5 is halfway.
    # @param scale [Float] a value between 0.0..1.0
    # @return [Api::Point2D]
    def lerp(other, scale)
      Api::Point2D[x + (other.x - x) * scale, y + (other.y - y) * scale]
    end

    # Distance calculations ---

    # Calculates the distance between self and other
    # @param other [Sc2::Position]
    # @return [Float]
    def distance_to(other)
      if other.nil? || other == self
        return 0.0
      end
      Math.hypot(self.x - other.x, self.y - other.y)
    end

    # The squared distance between this point and the other point.
    # @param other [Point2D] The other point to calculate the squared distance to.
    # @return [Float]
    def distance_squared_to(other)
      if other.nil? || other == self
        return 0.0
      end
      (x - other.x) * (y - other.y)
    end

    # Distance between this point and coordinate of x and y
    # @return [Float]
    def distance_to_coordinate(x:, y:)
      Math.hypot(self.x - x, self.y - y)
    end

    # The distance from this point to the circle.
    # @param center [Point2D] The center of the circle.
    # @param radius [Float] The radius of the circle.
    # @return [Float]
    def distance_to_circle(center, radius)
      distance_to_center = distance_to(center)
      if distance_to_center <= radius
        0.0 # Point is inside the circle
      else
        distance_to_center - radius
      end
    end

    # Movement ---

    # Moves in direction towards other point by distance
    # @param other [Api::Point2D] The target point to move to.
    # @param distance [Float] The distance to move.
    # @return [Api::Point2D]
    def towards(other, distance)
      direction = other.subtract(self).normalize
      add(direction.multiply(distance))
    end

    # Moves in direction away from the other point by distance
    # @param other [Api::Point2D] The target point to move away from
    # @param distance [Float] The distance to move.
    # @return [Api::Point2D]
    def away_from(other, distance)
      towards(other, -distance)
    end
  end
end

Api::Point.include Sc2::Position
Api::Point2D.include Sc2::Position
Api::PointI.include Sc2::Position
Api::Size2DI.include Sc2::Position
