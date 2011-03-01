module MobileHelper

  def mobile_footer_link(model_symbol)
    href = '#'
    href = send("#{model_symbol.to_s.pluralize}_path") unless
      model_symbol.to_s.singularize == controller.controller_name.singularize
    klass = mobile_active_button_class(model_symbol)
    rel = mobile_rel_external(model_symbol)

    content_tag :a, {:class => klass, :rel => rel, :href => href} do
      t(model_symbol)
    end
  end

  private

  def mobile_rel_external(model_symbol)
    if model_symbol.to_s.singularize != controller.controller_name.singularize
      return 'external'
    else
      return ''
    end
  end

  def mobile_active_button_class(model_symbol)
    if model_symbol.to_s.singularize == controller.controller_name.singularize
      return 'ui-btn-active' 
    else 
      return ''
    end
  end

end
