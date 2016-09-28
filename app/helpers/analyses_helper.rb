module AnalysesHelper
  # LEFT
  def arrow_direction_left?(*type)
    case type[0]
      when 'first'
        return 'back'
      when 'last'
        return 'forward'
      else
        return 'back'
    end
  end

  def slider_direction_left?(*type)
    case type[0]
      when 'first'
        return 'prev'
      when 'last'
        return 'next'
      else
        return 'prev'
    end
  end

  # RIGHT
  def arrow_direction_right?(*type)
    case type[0]
      when 'first'
        return 'prev'
      when 'last'
        return 'forward'
      else
        return 'forward'
    end
  end

  def slider_direction_right?(*type)
    case type[0]
      when 'first'
        return 'prev'
      when 'last'
        return 'next'
      else
        return 'next'
    end
  end


end
