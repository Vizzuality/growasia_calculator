class ItemCategory < EnumerateIt::Base
  associate_values :tillage, :fertilizer_type, :manure_type, :crop, :crop_unit,
    :nutrient_management, :rice_nutrient_management, :fuel_type, :fuel_unit,
    :type_of_rice, :irrigation_regime, :flooding
end
