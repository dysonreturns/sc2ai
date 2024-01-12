module Api
  # Adds additional functionality to message object Api::Unit
  module UnitTypeExtension
    def mood
      "Crafty"
    end
  end
end
Api::UnitTypeData.prepend Api::UnitTypeExtension
