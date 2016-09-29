module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def select_options data_source, selected=nil
    options_for_select(data_source.map{|t| [t[:title], t[:slug]]}, selected)
  end
end
