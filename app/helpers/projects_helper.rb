module ProjectsHelper
  def project_title_links(project)
    content_tag :h1 do
      [ project.title,
        link_to_icon('show', t(:show), project),
        link_to_icon('edit', t(:edit), edit_project_path(project)),
        link_to_icon('destroy', t(:destroy), project, {
          :confirm => t(:are_you_sure),
          :method => :delete
        })
      ].join(' ').html_safe
    end
  end
end
