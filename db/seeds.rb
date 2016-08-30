# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Crops
["Cocoa", "Coffee", "Tea", "Corn", "Potatoes", "Vegetables/horticulture",
 "Rice"].each do |crop|
  Item.create(name: crop, category: ItemCategory::CROP)
end
puts "#{Item.where(category: ItemCategory::CROP).count} Crops"

# Crop Units
["kg/ha", "t/ha"].each do |unit|
  Item.create(name: unit, category: ItemCategory::CROP_UNIT)
end
puts "#{Item.where(category: ItemCategory::CROP_UNIT).count} Crop units"

# Tillage
["No Tillage", "Minimal/shallow tillage",
 "Full tillage (major soil disturbance and/or multiple annual tillage operations)"].each do |tillage|
  Item.create(name: tillage, category: ItemCategory::TILLAGE)
end
puts "#{Item.where(category: ItemCategory::TILLAGE).count} tillage options"

# Fertilizer type
["Urea", "Ammonia", "Ammonium sulphate", "Monammonium sulphate (MAP)",
 "Diammonium sulphate (DAP)", "Ammonium nitrate", "Calcium ammonium nitrate"].each do |fertilizer|
  Item.create(name: fertilizer, category: ItemCategory::FERTILIZER_TYPE)
end
puts "#{Item.where(category: ItemCategory::FERTILIZER_TYPE).count} fertilizer types"

# Manure type
["Poultry litter, liquid", "Poultry litter, dry", "Other Manure, liquid",
 "Other Manure, dry"].each do |manure|
  Item.create(name: manure, category: ItemCategory::MANURE_TYPE)
end
puts "#{Item.where(category: ItemCategory::MANURE_TYPE).count} manure types"

# Nutrient Management
["Nitrogen fixing crop", "Cover crop", "Green manure", "Improved fallow",
 "Crop rotation", "Crop residue burning"].each do |nutrient|
  Item.create(name: nutrient, category: ItemCategory::NUTRIENT_MANAGEMENT)
end
puts "#{Item.where(category: ItemCategory::NUTRIENT_MANAGEMENT).count} nutrient management options"

# Rice Nutrient Management
["Straw <30 days before cultivation", "Straw >30 days after cultivation",
 "Compost", "Farm yard manure", "Green manure"].each do |nutrient|
  Item.create(name: nutrient, category: ItemCategory::RICE_NUTRIENT_MANAGEMENT)
end
puts "#{Item.where(category: ItemCategory::RICE_NUTRIENT_MANAGEMENT).count} rice nutrient management options"

# Fuel type
["Diesel", "Petroleum"].each do |fuel|
  Item.create(name: fuel, category: ItemCategory::FUEL_TYPE)
end
puts "#{Item.where(category: ItemCategory::FUEL_TYPE).count} fuel types"

# Fuel unit
["liters", "gallons"].each do |unit|
  Item.create(name: unit, category: ItemCategory::FUEL_UNIT)
end
puts "#{Item.where(category: ItemCategory::FUEL_UNIT).count} fuel units"

# Type of Rice
["Paddy", "Upland"].each do |rice|
  Item.create(name: rice, category: ItemCategory::TYPE_OF_RICE)
end
puts "#{Item.where(category: ItemCategory::TYPE_OF_RICE).count} types of rice"

# Irrigation Regime
["Continuous flooding", "Intermittent flooding (1 aeration)",
 "Intermittent flooding (multiple aerations)", "Rainfed: Regular",
 "Rainfed: Drought-prone", "Rainfed: Deep water potential"].each do |irrigation|
   Item.create(name: irrigation, category: ItemCategory::IRRIGATION_REGIME)
 end
puts "#{Item.where(category: ItemCategory::IRRIGATION_REGIME).count} irrigation regimes"

# Flooding
["Not flooded more than 6 months before cultivation",
 "Not flooded less than 6 months before cultivation",
 "Flooded for more than 30 days before cultivation"].each do |flood|
   Item.create(name: flood, category: ItemCategory::FLOODING)
 end
puts "#{Item.where(category: ItemCategory::FLOODING).count} flooding options"

