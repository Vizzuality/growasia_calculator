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
    {slug: "coccoa", title: "Cocoa"},
    {slug: "coffee", title: "Coffee"},
    {slug: "tea", title: "Tea"},
    {slug: "corn", title: "Corn"},
    {slug: "potatoes", title: "Potatoes"},
    {slug: "vegetables", title: "Vegetables/horticulture"},
    {slug: "rice", title: "Rice"}
  ]

  TILLAGES = [
    {slug: "no-tillage", title: "No Tillage", method: :fmg_no_till},
    {slug: "minimal", title: "Minimal/shallow tillage", method: :fmg_reduced},
    {slug: "full",
      title: "Full tillage (major soil disturbance and/or multiple annual tillage operations)",
      method: :fmg_full}
  ]

  FERTILIZER_TYPES = [
    {slug: "urea", title: "Urea"},
    {slug: "ammonia", title: "Ammonia"},
    {slug: "ammonia-sulphate", title: "Ammonium sulphate"},
    {slug: "map", title: "Monammonium phosphate (MAP)"},
    {slug: "dap", title: "Diammonium phosphate (DAP)"},
    {slug: "ammonia-nitrate", title: "Ammonium nitrate"},
    {slug: "calcium-ammonium", title: "Calcium ammonium nitrate"}
  ]

  MANURE_TYPES = [
    {slug: "poultry-liquid", title: "Poultry litter, liquid"},
    {slug: "poultry-dry", title: "Poultry litter, dry"},
    {slug: "other-liquid", title: "Other Manure, liquid"},
    {slug: "other-dry", title: "Other Manure, dry"}
  ]

  CROP_MANAGEMENT_PRACTICES = [
    {slug: "n-fix", title: "Nitrogen fixing crop"},
    {slug: "cover-crop", title: "Cover crop"},
    {slug: "green-manure", title: "Green manure"},
    {slug: "improved-fallow", title: "Improved fallow"},
    {slug: "crop-rot", title: "Crop rotation"},
    {slug: "residue-burning", title: "Crop residue burning"}
  ]

  FUEL_UNITS = [
    {slug: "liters", title: "liters"},
    {slug: "gallons", title: "gallons"}
  ]

  FUEL_TYPES = [
    {slug: "diesel", title: "Diesel"},
    {slug: "petroleum", title: "Petroleum"}
  ]

  IRRIGATION_REGIMES = [
    {slug: "cont-flood", title: "Continuous flooding"},
    {slug: "one-aeration", title: "Intermittent flooding (1 aeration)"},
    {slug: "multiple-aerations", title: "Intermittent flooding (multiple aerations)"},
    {slug: "rainfed-reg", title: "Rainfed: Regular"},
    {slug: "rainfed-drought", title: "Rainfed: Drought-prone"},
    {slug: "rainfed-deep", title: "Rainfed: Deep water potential"}
  ]

  FLOODING_PRACTICES = [
    {slug: "not-flooded-more",
      title: "Not flooded more than 6 months before cultivation"},
    {slug: "not-flooded-less",
      title: "Not flooded less than 6 months before cultivation"},
    {slug: "flooded",
      title: "Flooded for more than 30 days before cultivation"}
  ]

  RICE_NUTRIENT_MANAGEMENT = [
    {slug: "straw-less", title: "Straw <30 days before cultivation"},
    {slug: "straw-more", title: "Straw >30 days after cultivation"},
    {slug: "compost", title: "Compost"},
    {slug: "farm-yard", title: "Farm yard manure"},
    {slug: "green-manure", title: "Green manure"}
  ]

  # Emissions Equations
  def stable_soil_carbon_content
    #Stable soil carbon content (t CO2e) =
    # (Area * Cropland_SOCref*FLU*FMG*FI) /20 * 44/12
    fmg = geo_location.send(TILLAGES.select{|t| t[:slug] == tillage}.first[:method])
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
      !crop_management_practices.include?("residue-burning") &&
      (["cover-crop", "green-manure", "improved-fallow"]-crop_management_practices).size == 3

    # FI Low: None OR synthetic fert OR crop rot OR (n-fixing AND Crop residue Burning)
    return geo_location.fi_low if none_nutrient_management_practices? ||
      synthetic_or_crop_rot_or_n_fixing? &&
      crop_management_practices.include?("residue-burning")

    # FI high without manure = synthetic or crop rotation or n-fixing AND
    # NO burning of residues AND WITH cover crop/green manure/improved fallow
    return geo_location.fi_high_wo_manure if synthetic_or_crop_rot_or_n_fixing? &&
      !crop_management_practices.include?("residue-burning") &&
      (["cover-crop", "green-manure", "improved-fallow"]-crop_management_practices).size < 3
  end

  def none_nutrient_management_practices?
    !fertilizers.any? && !manures.any? && crop_management_practices.empty?
  end

  def synthetic_or_crop_rot_or_n_fixing?
    fertilizers.any? ||
      crop_management_practices.include?("crop-rot") ||
      crop_management_practices.include?("n-fix")
  end
end
