# Array extensions
class Array
  # Turns an Array of Api::Unit into a Sc2::UnitGroup
  # @return [Sc2::UnitGroup] array converted to a unit group
  def to_unit_group
    Sc2::UnitGroup.new(self)
  end

  # Creates a Point2D from 0,1 as x,y
  # @return [Api::Point2D]
  def to_p2d
    Api::Point2D.new(x: at(0), y: at(1))
  end
end
