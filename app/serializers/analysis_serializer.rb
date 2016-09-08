class AnalysisSerializer < ActiveModel::Serializer
  attributes :id, :area, :yield, :crop, :analysis

  belongs_to :geo_location

  def analysis
    total = 0.0

    # for stacked bars
    emissions_by_source = []
    if !object.rice?
      # Soil management
      sub_total = object.stable_soil_carbon_content
      emissions_by_source << {
        slug: "soil-mgmt",
        name: "Soil management",
        total: sub_total.to_f,
        values: [
          {
            slug: "soil-carbon-content",
            name: "Stable soil carbon content",
            value: sub_total.to_f
          }
        ]
      }
      total += sub_total

      # shaded
      if object.is_shaded?
        sub_total = object.changes_in_carbon_content
        emissions_by_source << {
          slug: "agroforestry",
          name: "Agroforestry removals",
          total: sub_total.to_f,
          values: [
            {
              slug: "changes-carbon-content",
              name: "Changes in carbon content",
              value: sub_total.to_f
            }
          ]
        }
        total += sub_total
      end
    end

    # Nutrient management
    nutrient_management = {
      slug: "nutrient-mgmt",
      name: "Nutrient Management"
    }
    sub_total = 0.0
    values = []
    if object.rice?
      val = object.emissions_from_rice_cultivation
      values << {
        slug: "rice-cultivation",
        name: "Rice cultivation",
        value: val.to_f
      }
      sub_total += val
    else
      val = object.emissions_from_crop_residue_decomposition
      values << {
        slug: "residue-decomposition",
        name: "Crop residue decomposition",
        value: val.to_f
      }
      sub_total += val
    end
    val = object.emissions_from_crop_residue_or_rice_straw_burning
    values << {
      slug: "residue-burning",
      name: "#{object.rice? ? "Rice straw" : "Crop residue"} burning",
      value: val.to_f
    }
    sub_total += val

    val = object.emissions_from_fertilizers_application
    values << {
      slug: "fertilizers",
      name: "Fertilizers Application",
      value: val.to_f
    }
    sub_total += val

    if object.fertilizers.where(addition_type: "urea").any?
      val = object.emissions_from_urea_hydrolysis
      values << {
        slug: "urea",
        name: "Urea hydrolysis",
        value: val.to_f
      }
      sub_total += val
    end
    nutrient_management[:total] = sub_total.to_f
    nutrient_management[:values] = values
    emissions_by_source << nutrient_management

    total += sub_total

    # Liming
    values = []
    sub_total = 0.0
    if object.lime_amount && object.lime_amount > 0.0
      val = object.emissions_from_lime_use
      values << {
        slug: 'liming',
        name: 'Lime use',
        value: val.to_f
      }
      sub_total += val
    end
    if object.dolomite_amount && object.dolomite_amount > 0.0
      val = object.emissions_from_dolomite_use
      values << {
        slug: 'dolomite',
        name: 'Dolomite use',
        value: val.to_f
      }
      sub_total += val
    end
    if sub_total > 0.0
      emissions_by_source << {
        slug: 'liming',
        name: 'Liming',
        total: sub_total.to_f,
        values: values
      }

      total += sub_total
    end

    if object.agrochemical_amount && object.agrochemical_amount > 0.0
      sub_total = object.emissions_from_agrochemical_use
      emissions_by_source << {
        slug: "agrochemical",
        name: "Agrochemical use",
        total: sub_total.to_f,
        values: [
          {
            slug: "agrochemical",
            name: "Agrochemical use",
            value: sub_total.to_f
          }
        ]
      }
      total += sub_total
    end
    sub_total = object.emissions_from_fossil_fuel_use
    emissions_by_source << {
      slug: "fuel",
      name: "Fossil fuel use",
      total: sub_total.to_f,
      values: [
        {
          slug: "fuel",
          name: "Fossil fuel use",
          value: sub_total.to_f
        }
      ]
    }
    total += sub_total

    {
      total: total.to_f,
      total_per_yield: (total/object.yield*object.area).to_f,
      emissions_by_source: [emissions_by_source]
    }
  end
end
