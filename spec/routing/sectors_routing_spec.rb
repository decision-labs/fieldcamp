require "spec_helper"

describe SectorsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/sectors" }.should route_to(:controller => "sectors", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/sectors/new" }.should route_to(:controller => "sectors", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/sectors/1" }.should route_to(:controller => "sectors", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/sectors/1/edit" }.should route_to(:controller => "sectors", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/sectors" }.should route_to(:controller => "sectors", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/sectors/1" }.should route_to(:controller => "sectors", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/sectors/1" }.should route_to(:controller => "sectors", :action => "destroy", :id => "1")
    end

  end
end
