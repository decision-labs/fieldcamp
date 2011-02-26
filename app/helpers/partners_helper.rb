module PartnersHelper
  def partner_name_links(partner)
    content_tag :h1 do
      [ partner.name,
        link_to_icon('show', t(:show), partner),
        link_to_icon('edit', t(:edit), edit_partner_path(partner)),
        link_to_icon('destroy', t(:destroy), partner, {
          :confirm => t(:are_you_sure),
          :method => :delete
        })
      ].join(' ').html_safe
    end
  end
end
