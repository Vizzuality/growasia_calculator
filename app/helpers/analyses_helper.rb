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

  def link_to_add_fields(name, f, association, upper_classes=nil, bottom_classes=nil)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    if upper_classes
      fields = fields.gsub("my-upper-class-replacement", upper_classes)
    end
    if bottom_classes
      fields = fields.gsub("my-bottom-class-replacement", bottom_classes)
    end
    link_to(name, '#', class: "add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
