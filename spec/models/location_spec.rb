require 'spec_helper'

describe Location do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "#child_projects" do
    it "should return projects with location.parent_id of the instance location" do

      parent_location = Location.make
      child_location  = Location.make(
        :parent_id => parent_location.id,
        :admin_level => parent_location.admin_level+1)
      project = Project.make(:location_id => child_location.id)
      project_parent = Project.make(:location_id => parent_location.id)

      parent_location.child_projects.should include(project)
      parent_location.child_projects.should include(project_parent)
    end
  end
end
