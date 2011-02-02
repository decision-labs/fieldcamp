module ProjectsHelper
  def project_title_link(project)
    content_tag :h1 do
      link_to h(project.title), project_path(project)
    end
  end
end
