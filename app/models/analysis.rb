class Analysis < ApplicationRecord
  belongs_to :geo_location

  CROPS = [
    "Cocoa",
    "Coffee",
    "Tea",
    "Corn",
    "Potatoes",
    "Vegetables/horticulture",
    "Rice"
  ]

  TILLAGES = [
    "No Tillage",
    "Minimal/shallow tillage",
    "Full tillage (major soil disturbance and/or multiple annual tillage operations)"
  ]

  FERTILIZER_TYPES = [
    "Urea",
    "Ammonia",
    "Ammonium sulphate",
    "Monammonium sulphate (MAP)",
    "Diammonium sulphate (DAP)",
    "Ammonium nitrate",
    "Calcium ammonium nitrate"
  ]

  MANURE_TYPES = [
    "Poultry litter, liquid",
    "Poultry litter, dry",
    "Other Manure, liquid",
    "Other Manure, dry"
  ]

  CROP_MANAGEMENT_PRACTICES = [
    "Nitrogen fixing crop", "Cover crop", "Green manure", "Improved fallow",
    "Crop rotation", "Crop residue burning"
  ]

  FUEL_UNITS = [
    "liters",
    "gallons"
  ]

  FUEL_TYPES = [
    "Diesel",
    "Petroleum"
  ]

  IRRIGATION_REGIMES = [
    "Continuous flooding",
    "Intermittent flooding (1 aeration)",
    "Intermittent flooding (multiple aerations)",
    "Rainfed: Regular",
    "Rainfed: Drought-prone",
    "Rainfed: Deep water potential"
  ]

  FLOODING_PRACTICES = [
    "Not flooded more than 6 months before cultivation",
    "Not flooded less than 6 months before cultivation",
    "Flooded for more than 30 days before cultivation"
  ]

  RICE_NUTRIENT_MANAGEMENT = [
    "Straw <30 days before cultivation",
    "Straw >30 days after cultivation",
    "Compost",
    "Farm yard manure",
    "Green manure"
  ]
end
