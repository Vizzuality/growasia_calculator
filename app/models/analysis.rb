class Analysis < ApplicationRecord
  belongs_to :geo_location

  has_many :fertilizers, -> { where category: Category::FERTILIZER },
    class_name: 'Addition'
  accepts_nested_attributes_for :fertilizers, allow_destroy: true

  has_many :manures, -> { where category: Category::MANURE },
    class_name: 'Addition'
  accepts_nested_attributes_for :manures, allow_destroy: true

  has_many :fuels, -> { where category: Category::FUEL },
    class_name: 'Addition'
  accepts_nested_attributes_for :fuels, allow_destroy: true

  has_many :nutrient_managements, -> { where category: Category::NUTRIENT_MANAGEMENT },
    class_name: 'Addition'
  accepts_nested_attributes_for :nutrient_managements, allow_destroy: true

  has_many :transportation_fuels, -> { where category: Category::TRANSPORTATION_FUEL },
    class_name: 'Addition'
  accepts_nested_attributes_for :transportation_fuels, allow_destroy: true

  has_many :irrigation_fuels, -> { where category: Category::IRRIGATION_FUEL },
    class_name: 'Addition'
  accepts_nested_attributes_for :irrigation_fuels, allow_destroy: true

  has_many :other_fuels, -> { where category: Category::OTHER_FUEL },
    class_name: 'Addition'
  accepts_nested_attributes_for :other_fuels, allow_destroy: true

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
    "Monammonium phosphate (MAP)",
    "Diammonium phosphate (DAP)",
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
    "Nitrogen fixing crop",
    "Cover crop",
    "Green manure",
    "Improved fallow",
    "Crop rotation",
    "Crop residue burning"
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

  # Emissions Equations
  def stable_soil_carbon_content
    #Stable soil carbon content (t CO2e) =
    # (Area * Cropland_SOCref*FLU*FMG*FI) /20 * 44/12
    fmg = case tillage
            when TILLAGES[0]
              geo_location.fmg_no_till
            when TILLAGES[1]
              geo_location.fmg_reduced
            when TILLAGES[2]
              geo_location.fmg_full
          end
    fi = correct_fi_value
    [(area * geo_location.soc_ref * geo_location.flu * fmg * fi) / 20 * 44/12,
     "t CO<sub>2</sub>e"]
  end

  def correct_fi_value
    # FI high with manure = Manure
    return geo_location.fi_high_w_manure if crop_management_practices.empty? &&
      !fertilizers.any? && manures.any?

    # FI medium = None OR synthetic OR crop rot OR n-fixing AND No Burning AND
    # NO cover crop / Green Manure / Improved Fallow
    return 1.00 if none_nutrient_management_practices? ||
      synthetic_or_crop_rot_or_n_fixing? &&
      !crop_management_practices.include?("Crop residue burning") &&
      (["Cover crop", "Green manure", "Improved fallow"]-crop_management_practices).size == 3

    # FI Low: None OR synthetic fert OR crop rot OR (n-fixing AND Crop residue Burning)
    return geo_location.fi_low if none_nutrient_management_practices? ||
      synthetic_or_crop_rot_or_n_fixing? &&
      crop_management_practices.include?("Crop residue burning")

    # FI high without manure = synthetic or crop rotation or n-fixing AND
    # NO burning of residues AND WITH cover crop/green manure/improved fallow
    return geo_location.fi_high_wo_manure if synthetic_or_crop_rot_or_n_fixing? &&
      !crop_management_practices.include?("Crop residue burning") &&
      (["Cover crop", "Green manure", "Improved fallow"]-crop_management_practices).size < 3
  end

  def none_nutrient_management_practices?
    !fertilizers.any? && !manures.any? && crop_management_practices.empty?
  end

  def synthetic_or_crop_rot_or_n_fixing?
    fertilizers.any? ||
      crop_management_practices.include?("Crop rotation") ||
      crop_management_practices.include?("Nitrogen fixing crop")
  end
end
