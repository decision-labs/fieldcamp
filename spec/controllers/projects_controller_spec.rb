require 'spec_helper'
require 'support/devise'

describe ProjectsController do

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end

  def mock_publisher_user(stubs={})
    @mock_publisher_user ||= mock_model(User, stubs.merge(:role =>'publisher'))
  end

  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, stubs.merge(:role =>'admin'))
  end

  describe "publisher role" do
    before(:each) do
      # sign_in mock_user
      request.env['warden'] = mock( Warden,
                                    :authenticate  => mock_publisher_user,
                                    :authenticate! => mock_publisher_user)
    end

    describe "GET new" do
      it "raises CanCan::AccessDenied exception" do
        lambda{get :new}.should raise_exception(CanCan::AccessDenied)
      end
    end

    describe "POST create" do
      it "raises CanCan::AccessDenied exception" do
        params = {:title => 'test'}
        lambda{post :create, :project => params }.should raise_exception(CanCan::AccessDenied)
      end
    end

    describe "GET edit" do
      it "raises CanCan::AccessDenied exception" do
        Project.stub(:find).with("37") { mock_project }
        lambda{get :edit, :id => "37"}.should raise_exception(CanCan::AccessDenied)
      end
    end

    describe "PUT update" do
      it "raises CanCan::AccessDenied exception" do
        Project.stub(:find).with("37") { mock_project }
        params = {'these' => 'params'}
        lambda{ put :update, :id => "37", :project => params }.should raise_exception(CanCan::AccessDenied)
      end
    end

    describe "DELETE destroy" do
      it "raises CanCan::AccessDenied exception" do
        Project.stub(:find).with("37") { mock_project }
        lambda{delete :destroy, :id => "37"}.should raise_exception(CanCan::AccessDenied)
      end
    end
  end # publisher role

  describe "admin role" do
    before(:each) do
      # sign_in mock_user
      request.env['warden'] = mock( Warden,
                                    :authenticate  => mock_admin_user,
                                    :authenticate! => mock_admin_user)
    end

    describe "GET index" do
      it "assigns all projects as @projects" do
        Project.stub(:all) { [mock_project] }
        get :index
        assigns(:projects).should eq([mock_project])
      end
    end

    describe "GET show" do
      it "assigns the requested project as @project" do
        Project.stub(:find).with("37", {:include=>[:location, :events]}) { mock_project }
        get :show, :id => "37"
        assigns(:project).should be(mock_project)
      end
    end

    describe "GET new" do
      it "assigns a new project as @project" do
        Project.stub(:new) { mock_project(:user_id => mock_user.id) }
        get :new
        assigns(:project).should be(mock_project(:user_id => mock_user.id))
      end
    end

    describe "GET edit" do
      it "assigns the requested project as @project" do
        Project.stub(:find).with("37") { mock_project }
        get :edit, :id => "37"
        assigns(:project).should be(mock_project)
      end
    end

    describe "POST create" do
      before(:all) do
        @params = {
          :title    => 'project',
          :sectors  => [1],
          :partners => [1]}

        @project_stub_methods = {
          :save => true,
          :sectors => [],
          :partners => []}
      end
      describe "with valid params" do
        it "assigns a newly created project as @project" do

          Project.stub(:new) {
            mock_project(@project_stub_methods)
          }

          post :create, :project => @params
          assigns(:project).should be(mock_project)
        end

        it "redirects to the created project" do
          Project.stub(:new) { mock_project(@project_stub_methods) }
          post :create, :project => @params
          response.should redirect_to(project_url(mock_project))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved project as @project" do
          Project.stub(:new).with({'these' => 'params'}) {
            mock_project( @project_stub_methods.merge(:save => false))
          }
          post :create, :project => {'these' => 'params'}
          assigns(:project).should be(mock_project)
        end

        it "re-renders the 'new' template" do
          Project.stub(:new).with({}) {
            mock_project( @project_stub_methods.merge(:save => false))
          }
          post :create, :project => {}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested project" do
          Project.stub(:find).with("37") { mock_project }
          mock_project.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :project => {'these' => 'params'}
        end

        it "assigns the requested project as @project" do
          Project.stub(:find) { mock_project(:update_attributes => true) }
          put :update, :id => "1"
          assigns(:project).should be(mock_project)
        end

        it "redirects to the project" do
          Project.stub(:find) { mock_project(:update_attributes => true) }
          put :update, :id => "1"
          response.should redirect_to(project_url(mock_project))
        end
      end

      describe "with invalid params" do
        it "assigns the project as @project" do
          Project.stub(:find) { mock_project(:update_attributes => false) }
          put :update, :id => "1"
          assigns(:project).should be(mock_project)
        end

        it "re-renders the 'edit' template" do
          Project.stub(:find) { mock_project(:update_attributes => false) }
          put :update, :id => "1"
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested project" do
        Project.stub(:find).with("37") { mock_project }
        mock_project.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the projects list" do
        Project.stub(:find) { mock_project }
        delete :destroy, :id => "1"
        response.should redirect_to(projects_url)
      end
    end

  end # admin role

end
