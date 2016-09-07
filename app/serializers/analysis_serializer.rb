class AnalysisSerializer < ActiveModel::Serializer
  attributes :id, :area, :yield, :crop, :analysis

  belongs_to :geo_location

  def analysis
    result = []
    if !object.rice?
      result << {stable_soil_carbon_content: object.stable_soil_carbon_content}
      if object.is_shaded?
        result << {changes_in_carbon_content: object.changes_in_carbon_content}
      end
      result << {emissions_from_crop_residue_decomposition: object.emissions_from_crop_residue_decomposition}
      result << {emissions_from_crop_residue: object.emissions_from_crop_residue_or_rice_straw_burning}
    else
      result << {emissions_from_rie_straw_residue: object.emissions_from_crop_residue_or_rice_straw_burning}
      result << {emissions_from_rice_cultivation: object.emissions_from_rice_cultivation}
    end
    result << {emissions_from_fertilizers_application: object.emissions_from_fertilizers_application}

    if object.fertilizers.where(addition_type: "urea").any?
      result << {emissions_from_urea_hydrolysis: object.emissions_from_urea_hydrolysis}
    end

    if object.lime_amount && object.lime_amount > 0.0
      result << {emissions_from_lime_use: object.emissions_from_lime_use}
    end
    if object.dolomite_amount && object.dolomite_amount > 0.0
      result << {emissions_from_dolomite_use:  object.emissions_from_dolomite_use}
    end

    if object.agrochemical_amount && object.agrochemical_amount > 0.0
      result << {emissions_from_agrochemical_use: object.emissions_from_agrochemical_use}
    end
    result << {emissions_from_fossil_fuel_use: object.emissions_from_fossil_fuel_use}

    result
  end
end
