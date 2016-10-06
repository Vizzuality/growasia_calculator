require 'test_helper'

class AnalysisTest < ActiveSupport::TestCase

  test "should calculate emissions_from_rice_cultivation" do
    analysis = Analysis.new({
      crop: "rice",
      area: 100,
      yield: 100,
      rice_type: "paddy",
      irrigation_regime: "one-aeration",
      flooding: "not-flooded-more",
      cultivation_time: 120,
      annual_cultivation_cycles: 1,
      nutrient_managements: [Addition.new({
        category: Category::NUTRIENT_MANAGEMENT,
        amount: 2000,
        addition_type: "straw-less"
      })]
     })
    analysis.save

    assert_equal 0.304, analysis.emissions_from_rice_cultivation.to_f.round(3)
  end

  test "should calculate emissions_from_fossil_fuel_use" do
    analysis = Analysis.new
    analysis.fuels << Addition.new({
      category: Category::FUEL,
      amount: 700,
      addition_type: "diesel",
      unit: "liters"
    })

    assert_equal 1.876, analysis.emissions_from_fossil_fuel_use
  end

  test "should calculate fi_value and return medium" do
    gl = GeoLocation.create({
      country: "Indonesia",
      state: "Lampung",
      fi_high_wo_manure: 1.11,
      fi_high_w_manure: 1.44,
      fi_low: 0.92,
      soc_ref: 83.32,
      fmg_reduced: 1.15,
      fmg_no_till: 1.22,
      fmg_full: 1.0,
      flu: 0.48
    })
    analysis = Analysis.new({
      crop: "corn",
      area: 100,
      yield: 100,
      geo_location: gl,
      crop_management_practices: ["residue-burning"],
      tillage: "minimal",
      fertilizers: [Addition.new({
        category: Category::FERTILIZER,
        amount: 2000,
        addition_type: "ammonia"
      })]
    })
    analysis.save!

    assert_equal 1.00, analysis.fi_value
    assert_equal false, analysis.fi_low?
    assert_equal false, analysis.fi_high_wo_manure?
    assert_equal -109.9824, analysis.emissions_from_soil_management
  end

  test "should calculate fi_value and return high w manure" do
    gl = GeoLocation.create({
      country: "Indonesia",
      state: "Lampung",
      fi_high_wo_manure: 1.11,
      fi_high_w_manure: 1.44,
      fi_low: 0.92,
      soc_ref: 83.32,
      fmg_reduced: 1.15,
      fmg_no_till: 1.22,
      fmg_full: 1.0,
      flu: 0.48
    })
    analysis = Analysis.new({
      crop: "corn",
      area: 100,
      yield: 100,
      geo_location: gl,
      crop_management_practices: ["green-manure"],
      fertilizers: [Addition.new({
        category: Category::FERTILIZER,
        amount: 2000,
        addition_type: "ammonia"
      })],
      manures: [Addition.new({
        category: Category::MANURE,
        amount: 2000,
        addition_type: "poultry-liquid"
      })]
    })
    analysis.save
    assert_equal gl.fi_high_w_manure, analysis.fi_value
    assert_equal false, analysis.fi_low?
    assert_equal false, analysis.fi_medium?
    assert_equal false, analysis.fi_high_wo_manure?
  end

  test "should calculate fi_value and return low" do
    gl = GeoLocation.create({
      country: "Myanmar",
      state: "Magway",
      fi_high_wo_manure: 1.04,
      fi_high_w_manure: 1.37,
      fi_low: 0.95,
      soc_ref: 66.63,
      fmg_reduced: 1.09,
      fmg_no_till: 1.17,
      fmg_full: 1.0,
      flu: 0.58
    })
    analysis = Analysis.new({
      crop: "vegetables",
      area: 500,
      yield: 100,
      geo_location: gl,
      crop_management_practices: ["residue-burning"],
      fertilizers: [],
      manures: [],
      tillage: "full"
    })
    analysis.save

    assert_equal gl.fi_low, analysis.fi_value
    assert_equal false, analysis.fi_medium?
    assert_equal false, analysis.fi_high_wo_manure?
    assert_equal 177.12475, analysis.emissions_from_soil_management

    old_fmg = analysis.fmg_value
    old_fi = analysis.fi_value

    # UPDATE analysis
    analysis.tillage = "minimal"
    analysis.crop_management_practices << "crop-rot"
    analysis.fertilizers << Addition.new({
      category: Category::FERTILIZER,
      amount: 2000,
      addition_type: "ammonia"
    })
    analysis.manures = []
    analysis.save

    assert_equal 1.0, analysis.fi_value
    assert_equal true, analysis.fi_medium?
    assert_equal false, analysis.fi_low?
    assert_equal false, analysis.fi_high_wo_manure?
    assert_equal 1.09, analysis.fmg_value.to_f
    assert_equal -495.9493, analysis.emissions_from_soil_management_changed(old_fmg, old_fi).to_f
  end

  test "should calculate flu_value and return correctly" do
    dummy_flu = 0.58
    gl = GeoLocation.create({
      country: "Myanmar",
      state: "Magway",
      fi_high_wo_manure: 1.04,
      fi_high_w_manure: 1.37,
      fi_low: 0.95,
      soc_ref: 66.63,
      fmg_reduced: 1.09,
      fmg_no_till: 1.17,
      fmg_full: 1.0,
      flu: dummy_flu
    })
    analysis = Analysis.new({
      crop: "vegetables",
      area: 500,
      yield: 100,
      geo_location: gl
    })
    analysis.save

    assert_equal dummy_flu, analysis.flu_value

    analysis.crop = "paddy-rice"
    analysis.save

    assert_equal 1.10, analysis.flu_value

    analysis.crop = "coffee"
    analysis.save

    assert_equal 1.0, analysis.flu_value
  end
end
