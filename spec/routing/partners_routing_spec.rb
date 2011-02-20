require "spec_helper"

describe PartnersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/partners" }.should route_to(:controller => "partners", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/partners/new" }.should route_to(:controller => "partners", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/partners/1" }.should route_to(:controller => "partners", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/partners/1/edit" }.should route_to(:controller => "partners", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/partners" }.should route_to(:controller => "partners", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/partners/1" }.should route_to(:controller => "partners", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/partners/1" }.should route_to(:controller => "partners", :action => "destroy", :id => "1")
    end

  end
end
