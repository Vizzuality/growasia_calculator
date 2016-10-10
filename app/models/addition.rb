class Addition < ApplicationRecord
  has_enumeration_for :category, with: Category, create_helpers: true

  def fertilizer_name
    fert = Analysis::FERTILIZER_TYPES.select{|t| t[:slug] == addition_type}.first
    fert && fert[:title] or "n/a"
  end

  def manure_name
    manure = Analysis::MANURE_TYPES.select{|t| t[:slug] == addition_type}.first
    manure && manure[:title] or "n/a"
  end

  def fuel_name
    fuel = Analysis::FUEL_TYPES.select{|t| t[:slug] == addition_type}.first
    fuel && fuel[:title] or "n/a"
  end

  def fuel_unit_name
    fuel = Analysis::FUEL_UNITS.select{|t| t[:slug] == unit}.first
    fuel && fuel[:title] or "n/a"
  end

  def nutrient_mgmt_name
    nutrient = Analysis::RICE_NUTRIENT_MANAGEMENT.select{|t| t[:slug] = addition_type}.first
    nutrient && nutrient[:title] or "n/a"
  end
end
