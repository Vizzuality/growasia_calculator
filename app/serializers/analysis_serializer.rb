class AnalysisSerializer < ActiveModel::Serializer
  attributes :id, :area, :yield, :yield_unit, :crop, :analysis

  belongs_to :geo_location

  def yield_unit
    "t per ha and yr"
  end

  def yield
    object.converted_yield
  end

  def analysis
    if instance_options[:analysis_params]
      old_fmg = object.fmg_value
      old_fi = object.fi_value
      object.assign_attributes(instance_options[:analysis_params])
    end

    total = 0.0

    per_yield = object.converted_yield*object.area

    # for stacked bars
    emissions_by_source = []
    val = if instance_options[:analysis_params] && (old_fmg != object.fmg_value || old_fi != object.fi_value)
            object.emissions_from_soil_management_changed(old_fmg, old_fi)
          else
            object.emissions_from_soil_management
          end
    emissions_by_source << {
      slug: "soil-mgmt",
      name: "Soil management",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    val = object.changes_in_carbon_content
    emissions_by_source << {
      slug: "agroforestry",
      name: "Agroforestry removals",
      total: val.to_f*-1.0,
      total_per_yield: (val/per_yield).to_f * -1.0
    }
    total -= val

    if object.paddy_rice?
      val = object.emissions_from_rice_cultivation
      emissions_by_source << {
        slug: "rice-irrigation",
        name: "Rice irrigation",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
    elsif !object.perennial?
      val = object.emissions_from_crop_residue_decomposition
      emissions_by_source << {
        slug: "residue-decomposition",
        name: object.upland_rice? ? "Rice straw decomposition" : "Crop residue decomposition",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
    end
    total += val

    if !object.perennial?
      val = object.emissions_from_crop_residue_or_rice_straw_burning
      emissions_by_source << {
        slug: "residue-burning",
        name: "#{object.rice? ? "Rice straw" : "Crop residue"} burning",
        total: val.to_f,
        total_per_yield: (val/per_yield).to_f
      }
      total += val
    end

    val = object.emissions_from_fertilizers_application
    emissions_by_source << {
      slug: "fertilizers",
      name: "Synthetic fertilizers application",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    val = object.emissions_from_manures_application
    emissions_by_source << {
      slug: "manures",
      name: "Manure application",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    val = object.emissions_from_urea_hydrolysis
    emissions_by_source << {
      slug: "urea",
      name: "Urea hydrolysis",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    val = object.emissions_from_lime_use
    val += object.emissions_from_dolomite_use
    emissions_by_source << {
      slug: 'liming',
      name: 'Liming',
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    val = object.emissions_from_agrochemical_use
    emissions_by_source << {
      slug: "agrochemical",
      name: "Pesticide and herbicide use",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    val = object.emissions_from_fossil_fuel_use
    emissions_by_source << {
      slug: "fuel",
      name: "Fossil fuels",
      total: val.to_f,
      total_per_yield: (val/per_yield).to_f
    }
    total += val

    {
      total: total.to_f,
      total_per_yield: (total/per_yield).to_f,
      emissions_by_source: emissions_by_source,
      analysis_changed: object.any_change?
    }
  end
end
