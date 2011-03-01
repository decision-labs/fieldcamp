module MobileHelper

  def mobile_rel_external(model_name)
    if model_name.singularize != controller.controller_name.singularize
      return 'external'
    else
      return ''
    end
  end

  def mobile_active_button_class(model_name)
    if model_name.singularize == controller.controller_name.singularize
      return 'ui-btn-active' 
    else 
      return ''
    end
  end

end
