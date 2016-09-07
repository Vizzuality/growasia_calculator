module ApplicationHelper
  def select_options data_source
    options_for_select(data_source.map{|t| [t[:title], t[:slug]]})
  end
end
