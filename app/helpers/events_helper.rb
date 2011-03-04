module EventsHelper
  # def model_title_links(m, t="title", header_level=:h2, parent_model = nil)
  #   path = [parent_model.try(:downcase), m.class.name.downcase, 'path'].compact.join('_')
  #   content_tag header_level, :class=>'title' do
  #     [ m.send(t),
  #       link_to_icon('show', t(:show), m ),
  #       (can? :update,  m) ? link_to_icon('edit', t(:edit), send(['edit', path].join('_') , m)) : nil,
  #       (can? :destroy, m) ? link_to_icon('destroy', t(:destroy), m, {
  #         :confirm => t(:are_you_sure),
  #         :method => :delete
  #       }) : nil
  #     ].compact.join(' ').html_safe
  #   end
  # end

end
