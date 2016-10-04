class Analysis < ApplicationRecord
  include DataSource

  belongs_to :geo_location
  has_many :additions

  has_many :fertilizers, -> { where category: Category::FERTILIZER },
    class_name: 'Addition'
  accepts_nested_attributes_for :fertilizers, allow_destroy: true,
    reject_if: proc { |a| a['amount'].blank? }

  has_many :manures, -> { where category: Category::MANURE },
    class_name: 'Addition'
  accepts_nested_attributes_for :manures, allow_destroy: true,
    reject_if: proc { |a| a['amount'].blank? }


  has_many :fuels, -> { where category: Category::FUEL },
    class_name: 'Addition'
  accepts_nested_attributes_for :fuels, allow_destroy: true,
    reject_if: proc { |a| a['amount'].blank? }


  has_many :nutrient_managements, -> { where category: Category::NUTRIENT_MANAGEMENT },
    class_name: 'Addition'
  accepts_nested_attributes_for :nutrient_managements, allow_destroy: true,
    reject_if: proc { |a| a['amount'].blank? }


  has_many :transportation_fuels, -> { where category: Category::TRANSPORTATION_FUEL },
    class_name: 'Addition'
  accepts_nested_attributes_for :transportation_fuels, allow_destroy: true,
    reject_if: proc { |a| a['amount'].blank? }


  has_many :irrigation_fuels, -> { where category: Category::IRRIGATION_FUEL },
    class_name: 'Addition'
  accepts_nested_attributes_for :irrigation_fuels, allow_destroy: true,
    reject_if: proc { |a| a['amount'].blank? }


  validates :area, :yield, :crop, presence: true


  def rice?
    crop == "rice"
  end

  # Emissions Equations
  def emissions_from_soil_management
    #Stable soil carbon content (t CO2e) =
    # (Area * Cropland_SOCref*FLU*FMG*FI) /20 * 44/12
    fmg = fmg_value
    fi = fi_value
    ((area * geo_location.soc_ref * geo_location.flu ) - ( area * geo_location.soc_ref * geo_location.flu * fmg * fi)) / 20 * 44/12
  end

  def emissions_from_soil_management_changed old_fmg, old_fi
    #Stable soil carbon content (t CO2e) =
    # (Area * Cropland_SOCref*FLU*FMG*FI) /20 * 44/12
    fmg = fmg_value
    fi = fi_value
    ((area * geo_location.soc_ref * geo_location.flu * old_fmg * old_fi) - ( area * geo_location.soc_ref * geo_location.flu * fmg * fi)) / 20 * 44/12
  end

  def fmg_value
    geo_location.send(TILLAGES.select{|t| t[:slug] == tillage}.first[:method])
  end

  def fi_value
    # FI high with manure = Manure
    return geo_location.fi_high_w_manure if manures.any?

    return geo_location.fi_low if fi_low?

    return 1.00 if fi_medium?

    return geo_location.fi_high_wo_manure if fi_high_wo_manure?

    1.0
  end

  def fi_low?
    # FI Low: None OR crop rot WITH burning of residues AND (NO cover crop
    # OR green manure OR improved fallow OR n-fixing OR synthetic)
    (
      (
        !additions.where(category: [Category::FERTILIZER, Category::MANURE]).any? &&
        (!crop_management_practices || crop_management_practices.empty?)
      ) ||
      (crop_management_practices && crop_management_practices.include?("crop-rot"))
    ) &&
    crop_management_practices && crop_management_practices.include?("residue-burning") &&
    (
      (
        !crop_management_practices.include?("cover-crop") ||
        crop_management_practices.include?("green-manure") ||
        crop_management_practices.include?("improved-fallow") ||
        crop_management_practices.include?("n-fix") ||
        fertilizers.any?
      ) && !manures.any?
    )
  end

  def fi_medium?
    # FI medium = Synthetic OR n-fixing AND No Burning AND (
    # NO cover crop && NO  Green Manure && NO Improved Fallow )
    (
      !manures.any? &&
      (
        fertilizers.any? ||
        (crop_management_practices && crop_management_practices.include?("n-fix"))
      )
    ) &&
    (["residue-burning", "cover-crop", "green-manure", "improved-fallow"] -
     crop_management_practices).size == 4
  end

  def fi_high_wo_manure?
    # FI high without manure = synthetic or crop rotation or n-fixing AND
    # NO burning of residues AND WITH cover crop/green manure/improved fallow
    (
      !manures.any? &&
      (
        fertilizers.any? ||
        (crop_management_practices && crop_management_practices.include?("n-fix"))
      )
    ) &&
    (crop_management_practices && !crop_management_practices.include?("residue-burning")) &&
    (
      crop_management_practices.include?("cover-crop") ||
      crop_management_practices.include?("green-manure") ||
      crop_management_practices.include?("improved-fallow")
    )
  end

  #Area (ha) * Amount of Fertilizer Applied (kg ha-1 yr-1) * %Nfertilizer type *
  # (EFfertilizer type application + EFfertilizer type production) / 1000
  def emissions_from_fertilizers_application
    emissions = 0.0
    fertilizers.each do |fert|
      fert_type = FERTILIZER_TYPES.select{|t| t[:slug] == fert.addition_type}.first
      emissions += area*fert.amount*fert_type[:nfertilizer_type]*
        (fert_type[:fertilizer_type_app] + fert_type[:fertilizer_type_prod]) / 1000
    end
    emissions
  end

  #Area (ha) * Amount of Fertilizer Applied (kg ha-1 yr-1) * %Nfertilizer type *
  # (EFfertilizer type application + EFfertilizer type production) / 1000
  def emissions_from_manures_application
    emissions = 0.0
    manures.each do |manure|
      manure_type = MANURE_TYPES.
                  select{|t| t[:slug] == manure.addition_type}.first
      emissions += area*manure.amount*manure_type[:nfertilizer_type]*
        (manure_type[:fertilizer_type_app] + manure_type[:fertilizer_type_prod]) / 1000
    end
    emissions
  end

  def emissions_from_crop_residue_decomposition
    # IF Crop Residue Burning is selected, then emissions from crop residue
    # decomposition = 0. All crop residue is assumed to be burned for cocoa,
    # coffee, and tea.
    return 0 if crop_management_practices && crop_management_practices.include?("residue-burning") ||
      ["cocoa", "coffee", "tea"].include?(crop)

    r = CROPS.select{|t| t[:slug] == crop}.first
    crop_residue = r[:final_default_residue_amount] ||
      converted_yield*r[:rpr]*(1-r[:moisture_content])

    # (t CO2-e) =[ (Area (ha) *
    # Crop residue (kg. ha-1yr-1) * NAG + (Crop residue (kg. ha-1 yr-1) * RBG *
    # NBG)) * 5.736] / 1000
    ((area*crop_residue*r[:n_ag] + (crop_residue*r[:r_bg]*r[:n_bg]))*5.736)/1000
  end

  def emissions_from_crop_residue_or_rice_straw_burning
    return 0.0 unless crop_management_practices && crop_management_practices.include?("residue-burning")

    #Emissions from crop residue burning (t CO2-e) = Area (ha) *
    # Crop residue (kg. ha-1yr-1) OR Rice Straw (kg. ha-1yr-1) * EFCrop Residue
    # OR EFRice Straw (kg CO2-e/kg d.m. burned)/100
    # EFCrop Residue = 1.6 (kg CO2-e/kg d.m. burned).
    # EFRice Straw = 1.5 (kg CO2-e/kg d.m. burned)
    r = CROPS.select{|t| t[:slug] == crop}.first

    crop_residue = r[:final_default_residue_amount] ||
      converted_yield*r[:rpr]*(1-r[:moisture_content])
    ef = rice? ? 1.5 : 1.6
    area * crop_residue * ef / 1000
  end

  def emissions_from_urea_hydrolysis
    return 0.0 unless fertilizers.where(addition_type: "urea").any?
    #Area (ha) * urea application (kg. ha-1yr-1) * 0.20 * (44/12) / 1000
    urea = fertilizers.where(addition_type: "urea").first
    area * urea.amount * 0.20 * (44/12) / 1_000
  end

  def emissions_from_lime_use
    return 0.0 unless lime_amount && lime_amount > 0.0
    #(Area (ha) * amount of lime applied (kg. ha-1. yr-1) * 0.12 * (44/12)) / 1000
    (area * lime_amount * 0.12 * (44/12)) / 1_000
  end

  def emissions_from_dolomite_use
    return 0.0 unless dolomite_amount && dolomite_amount > 0.0
    #(Area (ha) * amount of dolomite applied (kg. ha-1. yr-1) * 0.13 * (44/12)) / 1000
    (area * dolomite_amount * 0.13 * (44/12)) / 1_000
  end

  def emissions_from_agrochemical_use
    return 0.0 unless agrochemical_amount && agrochemical_amount > 0.0
    #(Area (ha) * amount of agrochemicals applied (kg. ha-1. yr-1) * 19.4 kg CO2/ha) / 1000
    (area * agrochemical_amount * 19.4) / 1_000
  end

  def emissions_from_fossil_fuel_use
    emissions = 0.0
    fuels.each do |fuel|
      fuel_type = FUEL_TYPES.select{|t| t[:slug] == fuel.addition_type}.first
      ef_to_use = fuel.unit == "liters" ? fuel_type[:ef_per_liter] : fuel_type[:ef_per_gallon]
      emissions += fuel.amount * ef_to_use / 1_000
    end
    transportation_fuels.each do |fuel|
      fuel_type = FUEL_TYPES.select{|t| t[:slug] == fuel.addition_type}.first
      ef_to_use = fuel.unit == "liters" ? fuel_type[:ef_per_liter] : fuel_type[:ef_per_gallon]
      emissions += fuel.amount * ef_to_use / 1_000
    end
    irrigation_fuels.each do |fuel|
      fuel_type = FUEL_TYPES.select{|t| t[:slug] == fuel.addition_type}.first
      ef_to_use = fuel.unit == "liters" ? fuel_type[:ef_per_liter] : fuel_type[:ef_per_gallon]
      emissions += fuel.amount * ef_to_use / 1_000
    end
    emissions
  end

  def changes_in_carbon_content
    return 0.0 if rice? || !agroforestry_practices?
    #(Area (ha) * Ccrop type Monoculture (t C ha-1)) + (Area (ha) *
    # Ccrop type Agroforestry (t C ha-1 yr-1)) *44/12
    r = CROPS.select{|t| t[:slug] == crop}.first
    area * r[:c_agroforestry] * 44/12
  end

  def emissions_from_rice_cultivation
    return 0.0 unless rice?
    # (EFrice * Number of Cultivation Days * Annual Number of Cultivation Cycles * Area * 10-6) * 25
    # EFrice = 1.30 * Water Regime Scaling Factor * Scaling Factor for
    # Pre-Cultivation Flooding *Scaling Factor for Organic Amendment
    # Water Regime Scaling Factor = irrigation_regimes[:scaling_factor]
    # Scaling Factor for Pre-Cultivation Flooding = flooding_practices[:scaling_factor]
    # Scaling Factor for Organic Amendment = (1 +Application Rate * Conversion Factor)^0.59
    # Application rate is the amount of nutrient_management divided by 1000 to conver to tonnes/ha
    # Conversion factor: rice_nutrient_management[:conversion_factor]
    regime = IRRIGATION_REGIMES.select{|t| t[:slug] == irrigation_regime}.first
    practice = FLOODING_PRACTICES.select{|t| t[:slug] == flooding}.first
    nutrient_mgt = RICE_NUTRIENT_MANAGEMENT.select{|t| t[:slug] == nutrient_managements.first.addition_type}.first

    water_scaling_factor = rice_type == "upland" ? 0 : regime[:scaling_factor]

    pre_cult_scaling_factor = practice[:scaling_factor]

    conversion_factor = (1+nutrient_managements.first.amount/1000*nutrient_mgt[:conversion_factor])**0.59

    ef_rice = 1.30 * water_scaling_factor * pre_cult_scaling_factor * conversion_factor

    (ef_rice * cultivation_time * annual_cultivation_cycles * area * (10**-6)) * 25
  end

  def converted_yield
    converted_yield ||= yield_unit == "ton" ? self.yield : self.yield*0.001
  end

  def display_crop
    txt = []
    txt << rice_type if rice?
    txt << crop
    txt.map(&:capitalize).join(" ")
  end

  def has_fuel? fuel, fuel_type=nil
    send("#{fuel_type ? "#{fuel_type}_" : ""}fuels").where(addition_type: fuel).any?
  end

  def geo_location_id= slug
    loc = GeoLocation.where(slug: slug).first
    write_attribute(:geo_location_id, loc.id) if loc
  end
end
