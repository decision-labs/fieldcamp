require 'spec_helper'

describe Location do

  before(:each) do
    @parent_location = Location.make
    @child_location  = Location.make(
      :parent_id => @parent_location.id,
      :admin_level => @parent_location.admin_level+1)
    @project = Project.make(:location_id => @child_location.id)
    @project_parent = Project.make(:location_id => @parent_location.id)
    @events = []
    10.times{ @project.events << Event.make(:project_id => @project) }
    5.times { @project_parent.events << Event.make(:project_id => @project_parent) }
    puts @project.events.size
  end

  describe "#child_projects" do
    it "should return projects with location.parent_id of the instance location" do
      @parent_location.child_projects.all.should include(@project)
      @parent_location.child_projects.all.should include(@project_parent)
    end
  end
end
