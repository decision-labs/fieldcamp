require "spec_helper"

describe SearchController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/search" }.should route_to(:controller => "search", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/search/new" }.should route_to(:controller => "search", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/search/1" }.should route_to(:controller => "search", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/search/1/edit" }.should route_to(:controller => "search", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/search" }.should route_to(:controller => "search", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/search/1" }.should route_to(:controller => "search", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/search/1" }.should route_to(:controller => "search", :action => "destroy", :id => "1")
    end

  end
end
