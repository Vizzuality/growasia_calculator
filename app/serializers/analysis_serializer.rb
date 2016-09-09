class AnalysisSerializer < ActiveModel::Serializer
  attributes :id, :area, :yield, :crop, :analysis

  belongs_to :geo_location

  def analysis
    if instance_options[:analysis_params]
      object.assign_attributes(instance_options[:analysis_params])
    end

    total = 0.0
    per_yield = object.yield*object.area

    # for stacked bars
    emissions_by_source = []
    if !object.rice?
      # Soil management
      val = object.stable_soil_carbon_content
      emissions_by_source << {
        slug: "soil-mgmt",
        name: "Soil management",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
      total += val

      # shaded
      if object.is_shaded?
        val = object.changes_in_carbon_content
        emissions_by_source << {
          slug: "agroforestry",
          name: "Agroforestry removals",
          total: val.to_f,
          total_per_yield: (val/per_yield).to_f
        }
        total += val
      end
    end

    if object.rice?
      val = object.emissions_from_rice_cultivation
      emissions_by_source << {
        slug: "rice-cultivation",
        name: "Rice cultivation",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
    else
      val = object.emissions_from_crop_residue_decomposition
      emissions_by_source << {
        slug: "residue-decomposition",
        name: "Crop residue decomposition",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
    end
    total += val

    val = object.emissions_from_crop_residue_or_rice_straw_burning
    emissions_by_source << {
      slug: "residue-burning",
      name: "#{object.rice? ? "Rice straw" : "Crop residue"} burning",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    val = object.emissions_from_fertilizers_application
    emissions_by_source << {
      slug: "fertilizers",
      name: "Fertilizers Application",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    if object.fertilizers.where(addition_type: "urea").any?
      val = object.emissions_from_urea_hydrolysis
      emissions_by_source << {
        slug: "urea",
        name: "Urea hydrolysis",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
      total += val
    end

    val = 0.0
    if object.lime_amount && object.lime_amount > 0.0
      val = object.emissions_from_lime_use
    end
    if object.dolomite_amount && object.dolomite_amount > 0.0
      val += object.emissions_from_dolomite_use
    end
    emissions_by_source << {
      slug: 'liming',
      name: 'Lime and Dolomite use',
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    if object.agrochemical_amount && object.agrochemical_amount > 0.0
      val = object.emissions_from_agrochemical_use
      emissions_by_source << {
        slug: "agrochemical",
        name: "Agrochemical use",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
      total += val
    end
    val = object.emissions_from_fossil_fuel_use
    emissions_by_source << {
      slug: "fuel",
      name: "Fossil fuel use",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    {
      total: total.to_f,
      total_per_yield: (total/per_yield).to_f,
      emissions_by_source: emissions_by_source
    }
  end
end
