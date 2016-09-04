class Category < EnumerateIt::Base
  associate_values :fertilizer, :manure, :fuel, :nutrient_management,
    :transportation_fuel, :irrigation_fuel
end
