module SearchHelper
  def projects_search_description(tokens_hash)
    haml_tag(:div, :class => 'notice') do
      haml_concat t('projects_found_which_are')
      notice_strings = []

      if !tokens_hash[:locations].blank?
        notice_strings << t('located_in') + ": " + tokens_hash[:locations].each.map{ |n| n["name"] }.join(', ')
      end
      if !tokens_hash[:sectors].blank?
        notice_strings <<  t('in_sectors') + ": " + tokens_hash[:sectors].each.map{ |n| n["name"] }.join(', ')
      end
      if !tokens_hash[:partners].blank?
        notice_strings << t('with_partners') + ": " + tokens_hash[:partners].each.map{ |n| n["name"] }.join(', ')
      end
      haml_concat notice_strings.join(" "+t('and')+" ")
    end
  end

  def events_search_description(tokens_hash)
    haml_tag(:div, :class => 'notice') do
      haml_concat t('events_found_which_are')
      notice_strings = []

      if !tokens_hash[:locations].blank?
        notice_strings << t('located_in') + ": " + tokens_hash[:locations].each.map{ |n| n["name"] }.join(', ')
      end
      if !tokens_hash[:sectors].blank?
        notice_strings <<  t('in_sectors') + ": " + tokens_hash[:sectors].each.map{ |n| n["name"] }.join(', ')
      end
      if !tokens_hash[:partners].blank?
        notice_strings << t('with_partners') + ": " + tokens_hash[:partners].each.map{ |n| n["name"] }.join(', ')
      end
      haml_concat notice_strings.join(" "+t('and')+" ")
    end
  end

end
