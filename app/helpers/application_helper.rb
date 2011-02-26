module ApplicationHelper

  def link_to_icon(icon_name, icon_title, url_or_object, options={})
    options.merge!({ :class => "icon #{icon_name}" })

    link_to(image_tag("icons/#{icon_name}.png", { :title => icon_title }),
                      url_or_object,
                      options)
  end

  # Return the string 'first' if the passed object is the first
  # in the array.
  #
  # Used by CSS.
  def dom_class_first(object, array)
    if (object == array.first)
      return "first"
    end
    nil
  end

  def model_title_links(m, t="title")
    content_tag :h1 do
      [ m.send(t),
        link_to_icon('show', t(:show), m),
        link_to_icon('edit', t(:edit), send("edit_#{m.class.name.downcase}_path", m)),
        link_to_icon('destroy', t(:destroy), m, {
          :confirm => t(:are_you_sure),
          :method => :delete
        })
      ].join(' ').html_safe
    end
  end

end
