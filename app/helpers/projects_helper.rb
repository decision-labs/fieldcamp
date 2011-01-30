module ProjectsHelper
  def project_title_links(project)
    content_tag :h1 do
      project.title
    end
  end
end
