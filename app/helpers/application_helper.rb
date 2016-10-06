module ApplicationHelper
  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  def select_options data_source, selected=nil
    options_for_select(data_source.sort{|a,b| a[:title] <=> b[:title]}.
                       map{|t| [t[:title], t[:slug]]}, selected)
  end
end
