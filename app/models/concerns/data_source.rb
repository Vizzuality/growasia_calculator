module DataSource
  extend ActiveSupport::Concern

  PADDY_RICE = "paddy-rice"
  UPLAND_RICE = "upland-rice"
  COFFEE = "coffee"
  TEA = "tea"
  CACAO = "cacao"
  CORN = "corn"
  POTATOES = "potatoes"
  VEGETABLES = "vegetables"

  CROPS = [
    {slug: CACAO, title: "Cacao", residue_amount: 25_000, rpr: nil,
      moisture_content: nil, final_default_residue_amount: 25_000,
      n_ag: nil, r_bg: nil, n_bg: nil, c_monoculture: 11, c_agroforestry: 6},
    {slug: COFFEE, title: "Coffee", residue_amount: nil, rpr: 21,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: nil, r_bg: nil, n_bg: nil, c_monoculture: 18, c_agroforestry: 6},
    {slug: TEA, title: "Tea", residue_amount: nil, rpr: 21,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: nil, r_bg: nil, n_bg: nil, c_monoculture: 50.9, c_agroforestry: 2.6},
    {slug: CORN, title: "Corn", residue_amount: nil, rpr: 2,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: 0.006, r_bg: 0.22, n_bg: 0.007, c_monoculture: 5.0, c_agroforestry: 2.6},
    {slug: POTATOES, title: "Potatoes", residue_amount: nil, rpr: 0.3,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: 0.019, r_bg: 0.20, n_bg: 0.014, c_monoculture: 5.0, c_agroforestry: 2.6},
    {slug: VEGETABLES, title: "Vegetables/horticulture", residue_amount: nil, rpr: 1.53,
      moisture_content: 0.15, final_default_residue_amount: nil,
      n_ag: 0.008, r_bg: 0.19, n_bg: 0.008, c_monoculture: 5.0, c_agroforestry: 2.6},
    {slug: UPLAND_RICE, title: "Upland Rice", residue_amount: nil, rpr: 1.757,
      moisture_content: 0.127, final_default_residue_amount: nil,
      n_ag: 0.007, r_bg: 0.16, n_bg: nil, c_monoculture: nil, c_agroforestry: nil},
    {slug: PADDY_RICE, title: "Paddy Rice", residue_amount: nil, rpr: 1.757,
      moisture_content: 0.127, final_default_residue_amount: nil,
      n_ag: 0.007, r_bg: 0.16, n_bg: nil, c_monoculture: nil, c_agroforestry: nil}
  ]

  YIELD_UNITS = [
    {slug: "ton", title: "t/ha"},
    {slug: "kg", title: "kg/ha"}
  ]

  TILLAGES = [
    {slug: "no-tillage", title: "No Tillage", method: :fmg_no_till},
    {slug: "minimal", title: "Minimal/shallow tillage", method: :fmg_reduced},
    {slug: "full",
      title: "Full tillage (major soil disturbance and/or multiple annual tillage operations)",
      method: :fmg_full}
  ]

  FERTILIZER_TYPES = [
    {slug: "urea", title: "Urea", nfertilizer_type: 0.46,
      fertilizer_type_prod: 1.54, fertilizer_type_app: 6.205},
    {slug: "ammonia", title: "Ammonia", nfertilizer_type: 0.82,
      fertilizer_type_prod: 1.35, fertilizer_type_app: 6.205},
    {slug: "ammonia-sulphate", title: "Ammonium sulphate", nfertilizer_type: 0.21,
      fertilizer_type_prod: 0.35, fertilizer_type_app: 6.205},
    {slug: "map", title: "(MAP) Monammonium phosphate", nfertilizer_type: 0.11,
      fertilizer_type_prod: 0.18, fertilizer_type_app: 6.205},
    {slug: "dap", title:  "(DAP) Diammonium phosphate", nfertilizer_type: 0.18,
      fertilizer_type_prod: 0.3, fertilizer_type_app: 6.205},
    {slug: "ammonia-nitrate", title: "Ammonium nitrate", nfertilizer_type: 0.335,
      fertilizer_type_prod: 0.55, fertilizer_type_app: 6.205},
    {slug: "calcium-ammonium", title: "Calcium ammonium nitrate", nfertilizer_type: 0.27,
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
    {slug: "diesel", title: "Diesel", ef_per_gallon: 10.15,
      ef_per_liter: 2.68},
    {slug: "petroleum", title: "Petroleum", ef_per_gallon: 8.91,
      ef_per_liter: 2.35}
  ]

  IRRIGATION_REGIMES = [
    {slug: "cont-flood", title: "Continuous flooding", scaling_factor: 1.0},
    {slug: "one-aeration", title: "Intermittent flooding (1 aeration)", scaling_factor: 0.6},
    {slug: "multiple-aerations", title: "Intermittent flooding (multiple aerations)", scaling_factor: 0.52},
    {slug: "rainfed-reg", title: "Rainfed: Regular", scaling_factor: 0.28},
    {slug: "rainfed-drought", title: "Rainfed: Drought-prone", scaling_factor: 0.25},
    {slug: "rainfed-deep", title: "Rainfed: Deep water potential", scaling_factor: 0.31}
  ]

  FLOODING_PRACTICES = [
    {slug: "not-flooded-more",
      title: "Not flooded more than 6 months before cultivation",
      scaling_factor: 0.68},
    {slug: "not-flooded-less",
      title: "Not flooded less than 6 months before cultivation",
      scaling_factor: 1},
    {slug: "flooded",
      title: "Flooded for more than 30 days before cultivation",
      scaling_factor: 1.9}
  ]

  RICE_NUTRIENT_MANAGEMENT = [
    {slug: "straw-less", title: "Straw <30 days before cultivation",
      conversion_factor: 1},
    {slug: "straw-more", title: "Straw >30 days after cultivation",
      conversion_factor: 0.29},
    {slug: "compost", title: "Compost", conversion_factor: 0.05},
    {slug: "farm-yard", title: "Farm yard manure", conversion_factor: 0.14},
    {slug: "green-manure", title: "Green manure", conversion_factor: 0.5}
  ]

  def paddy_rice?
    PADDY_RICE == crop
  end

  def upland_rice?
    UPLAND_RICE == crop
  end

  def rice?
    [UPLAND_RICE, PADDY_RICE].include?(crop)
  end

  def perennial?
    [COFFEE, CACAO, TEA].include?(crop)
  end

  def perennial_or_paddy?
    paddy_rice? || perennial?
  end
end

