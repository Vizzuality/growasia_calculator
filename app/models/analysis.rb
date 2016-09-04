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
    {slug: "coccoa", title: "Cocoa", residue_amount: 25_000, rpr: nil,
      moisture_content: nil, final_default_residue_amount: 25_000,
      n_ag: nil, r_bg: nil, n_bg: nil},
    {slug: "coffee", title: "Coffee", residue_amount: nil, rpr: 21,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: nil, r_bg: nil, n_bg: nil},
    {slug: "tea", title: "Tea", residue_amount: nil, rpr: nil,
      moisture_content: nil, final_default_residue_amount: nil,
      n_ag: nil, r_bg: nil, n_bg: nil},
    {slug: "corn", title: "Corn", residue_amount: nil, rpr: 2,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: 0.006, r_bg: 0.22, n_bg: 0.007},
    {slug: "potatoes", title: "Potatoes", residue_amount: nil, rpr: 0.3,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: 0.019, r_bg: 0.20, n_bg: 0.014},
    {slug: "vegetables", title: "Vegetables/horticulture", residue_amount: nil, rpr: 1.53,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: 0.008, r_bg: 0.19, n_bg: 0.008},
    {slug: "rice", title: "Rice", residue_amount: nil, rpr: 1.757,
      moisture_content: 0.127, final_default_residue_amount: nil,
      n_ag: 0.007, r_bg: 0.16, n_bg: nil}
  ]

  TILLAGES = [
    {slug: "no-tillage", title: "No Tillage", method: :fmg_no_till},
    {slug: "minimal", title: "Minimal/shallow tillage", method: :fmg_reduced},
    {slug: "full",
      title: "Full tillage (major soil disturbance and/or multiple annual tillage operations)",
      method: :fmg_full}
  ]

  FERTILIZER_TYPES = [
    {slug: "urea", title: "Urea", nfertilizer_type: 46,
      fertilizer_type_prod: 1.54, fertilizer_type_app: 6.205},
    {slug: "ammonia", title: "Ammonia", nfertilizer_type: 82,
      fertilizer_type_prod: 1.35, fertilizer_type_app: 6.205},
    {slug: "ammonia-sulphate", title: "Ammonium sulphate", nfertilizer_type: 21,
      fertilizer_type_prod: 0.35, fertilizer_type_app: 6.205},
    {slug: "map", title: "Monammonium phosphate (MAP)", nfertilizer_type: 11,
      fertilizer_type_prod: 0.18, fertilizer_type_app: 6.205},
    {slug: "dap", title: "Diammonium phosphate (DAP)", nfertilizer_type: 18,
      fertilizer_type_prod: 0.3, fertilizer_type_app: 6.205},
    {slug: "ammonia-nitrate", title: "Ammonium nitrate", nfertilizer_type: 33.5,
      fertilizer_type_prod: 0.55, fertilizer_type_app: 6.205},
    {slug: "calcium-ammonium", title: "Calcium ammonium nitrate", nfertilizer_type: 27,
      fertilizer_type_prod: 0.43, fertilizer_type_app: 6.205}
  ]

  MANURE_TYPES = [
    {slug: "poultry-liquid", title: "Poultry litter, liquid", nfertilizer_type: 0.9,
      fertilizer_type_prod: 0, fertilizer_type_app: 6.673},
    {slug: "poultry-dry", title: "Poultry litter, dry", nfertilizer_type: 4.5,
      fertilizer_type_prod: 0, fertilizer_type_app: 6.673},
    {slug: "other-liquid", title: "Other Manure, liquid", nfertilizer_type: 0.7,
      fertilizer_type_prod: 0, fertilizer_type_app: 6.673},
    {slug: "other-dry", title: "Other Manure, dry", nfertilizer_type: 0.0195,
      fertilizer_type_prod: 0, fertilizer_type_app: 6.673}
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
    (area * geo_location.soc_ref * geo_location.flu * fmg * fi) / 20 * 44/12
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

  #Area (ha) * Amount of Fertilizer Applied (kg ha-1 yr-1) * %Nfertilizer type *
  # (EFfertilizer type application + EFfertilizer type production) / 1000
  def emissions_from_fertilizers_application
    results = []
    fertilizers.each do |fert|
      fert_type = FERTILIZER_TYPES.select{|t| t[:slug] == fert.addition_type}.first
      result = {type: fert.addition_type,
                category: fert.category,
                type_title: fert_type[:title]}
      result[:value] = area*fert.amount*fert_type[:nfertilizer_type]*
        (fert_type[:fertilizer_type_app] + fert_type[:fertilizer_type_prod]) /
        1000
      results << result
    end
    manures.each do |manure|
      manure_type = MANURE_TYPES.
                  select{|t| t[:slug] == manure.addition_type}.first
      result = {type: manure.addition_type,
                category: manure.category,
                type_title: manure_type[:title]}
      result[:value] = area*manure.amount*manure_type[:nfertilizer_type]*
        (manure_type[:fertilizer_type_app] + manure_type[:fertilizer_type_prod]) /
        1000
      results << result
    end
    results
  end

  def emissions_from_crop_residue_decomposition
    #IF Crop Residue Burning is selected, then emissions from crop residue
    # decomposition = 0. All crop residue is assumed to be burned for cocoa,
    # coffee, and tea.
    return 0 if crop_management_practices.include?("residue-burning") ||
      ["coccoa", "coffee", "tea"].include?(crop)

    r = CROPS.select{|t| t[:slug] == crop}.first
    crop_residue = r[:final_default_residue_amount] ||
      self.yield*r[:rpr]*(1-r[:moisture_content])

    # (t CO2-e) =[ (Area (ha) *
    # Crop residue (kg. ha-1yr-1) * NAG + (Crop residue (kg. ha-1 yr-1) * RBG *
    # NBG)) * 5.736] / 1000
    ((area*crop_residue*r[:n_ag] + (crop_residue*r[:r_bg]*r[:n_bg]))*5.736)/1000
  end

  def emissions_from_crop_residue_or_rice_straw_burning
    #Emissions from crop residue burning (t CO2-e) = Area (ha) *
    # Crop residue (kg. ha-1yr-1) OR Rice Straw (kg. ha-1yr-1) * EFCrop Residue
    # OR EFRice Straw (kg CO2-e/kg d.m. burned)/100
    # EFCrop Residue = 1.6 (kg CO2-e/kg d.m. burned).
    # EFRice Straw = 1.5 (kg CO2-e/kg d.m. burned)
    r = CROPS.select{|t| t[:slug] == crop}.first
    crop_residue = r[:final_default_residue_amount] ||
      self.yield*r[:rpr]*(1-r[:moisture_content])
    ef = crop == "rice" ? 1.5 : 1.6
    area * crop_residue * ef
  end

  def emissions_from_urea_hydrolysis
    return nil unless fertilizers.where(addition_type: "urea").any?
    #Area (ha) * urea application (kg. ha-1yr-1) * 0.20 * (44/12) / 1000
    urea = fertilizers.where(addition_type: "urea").first
    area * urea.amount * 0.20 * (44/12) / 1_000
  end

  def emissions_from_lime_use
    return nil unless lime_amount && lime_amount > 0.0
    #(Area (ha) * amount of lime applied (kg. ha-1. yr-1) * 0.12 * (44/12)) / 1000
    (area * lime_amount * 0.12 * (44/12)) / 1_000
  end

  def emissions_from_dolomite_use
    return nil unless dolomite_amount && dolomite_amount > 0.0
    #(Area (ha) * amount of dolomite applied (kg. ha-1. yr-1) * 0.13 * (44/12)) / 1000
    (area * dolomite_amount * 0.13 * (44/12)) / 1_000
  end

  def emissions_from_agrochemical_use
    return nil unless agrochemical_amount && agrochemical_amount > 0.0
    #(Area (ha) * amount of agrochemicals applied (kg. ha-1. yr-1) * 19.4 kg CO2/ha) / 1000
    (area * agrochemical_amount * 19.4) / 1_000
  end
end
