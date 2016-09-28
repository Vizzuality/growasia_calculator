require 'test_helper'

class AnalysisTest < ActiveSupport::TestCase

  test "should calculate emissions_from_rice_cultivation" do
    analysis = Analysis.new({
      crop: "rice",
      area: 100,
      rice_type: "paddy",
      irrigation_regime: "one-aeration",
      flooding: "not-flooded-more",
      cultivation_time: 120,
      nutrient_managements: [Addition.new({
        category: Category::NUTRIENT_MANAGEMENT,
        amount: 2000,
        addition_type: "straw-less"
      })]
     })
    analysis.save

    assert_equal 0.304, analysis.emissions_from_rice_cultivation.to_f.round(3)
  end
end
