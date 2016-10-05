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

  def select_to_add_fields(name, f, association, options)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    select_tag("#{id}_#{association.to_s}", options, include_blank: name,
               class: "-js-select_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def icon_to_add_more(f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_sidebar_fields", f: builder)
    end
    link_to(image_tag("add.svg", size: "18x18"), "#", class: "-js-add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end
end
