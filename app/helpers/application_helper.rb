module ApplicationHelper

  def link_to_icon(icon_name, icon_title, url_or_object, options={})
    options.merge!({ :class => "icon #{icon_name}" })

    link_to(image_tag("icons/#{icon_name}.png", { :title => icon_title}),
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
      content_tag :h2, :class=>'title' do
        [ m.send(t),
          link_to_icon('show', t(:show), m),
          (can? :update,  m) ? link_to_icon('edit', t(:edit), send("edit_#{m.class.name.downcase}_path", m)) : nil,
          (can? :destroy, m) ? link_to_icon('destroy', t(:destroy), m, {
            :confirm => t(:are_you_sure),
            :method => :delete
          }) : nil
        ].compact.join(' ').html_safe
      end
    end

    def event_title_links(event, project)
      content_tag :h3, :class=>'title' do
        [ event.title,
          link_to_icon('show', t(:show), project_event_path(project,event)),
          (can? :update,  event) ? link_to_icon('edit', t(:edit), edit_project_event_path(project, event)) : nil,
          (can? :destroy, event) ? link_to_icon('destroy', t(:destroy), project_event_path(project,event), {
            :confirm => t(:are_you_sure),
            :method => :delete
          }) : nil
        ].compact.join(' ').html_safe
      end
    end

  def title(page_title)
    content_for(:title, page_title.to_s)
  end

  def title_fallback
    ['Caritas', controller.controller_name, controller.action_name].compact.join(' :: ')
  end

  def static_map_img_link(event)
    marker = "marker=size:big|label:E|#{event.geom.y},#{event.geom.x}"
    center = "center=#{event.geom.y},#{event.geom.x}"
    "http://staticmaps.cloudmade.com/8ee2a50541944fb9bcedded5165f09d9/staticmap?size=460x200&#{center}&zoom=10&styleid=1&#{marker}"
  end

end
