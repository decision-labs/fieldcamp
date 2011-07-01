module ArticlesHelper
  include ApplicationHelper

  def article_title_links(m, t="title")
      content_tag :h2, :class=>'title' do
        [ m.send(t),
          link_to_icon('show', t(:show), m),
          (can? :update,  m) ? link_to_icon('edit', t(:edit), send("edit_#{m.class.name.downcase}_path", m)) : nil,
          (can? :destroy, m) ? link_to_icon('destroy', t(:destroy), m, { :confirm => t(:are_you_sure), :method => :delete }) : nil,
          m.published? ?
            (can? :unpublish, m) ? link_to(t(:unpublish), unpublish_article_path(m), { :confirm => t(:are_you_sure), :method => :put }) : nil
            :
            "draft"
        ].compact.join(' ').html_safe
      end
    end
  
end
