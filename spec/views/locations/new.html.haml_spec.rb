require 'spec_helper'

describe "locations/new.html.haml" do
  before(:each) do
    assign(:location, stub_model(Location,
      :name => "MyString",
      :description => "MyText",
      :admin_level => 1,
      :geom => ""
    ).as_new_record)
  end

  it "renders new location form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => locations_path, :method => "post" do
      assert_select "input#location_name", :name => "location[name]"
      assert_select "textarea#location_description", :name => "location[description]"
      assert_select "input#location_admin_level", :name => "location[admin_level]"
      assert_select "input#location_geom", :name => "location[geom]"
    end
  end
end
