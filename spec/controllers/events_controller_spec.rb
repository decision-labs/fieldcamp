require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe EventsController do

  def mock_event(stubs={})
    @mock_event ||= mock_model(Event, stubs)
  end

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  def mock_admin_user(stubs={})
    @mock_admin_user ||= mock_model(User, stubs.merge(:role => 'admin'))
  end

  def mock_publisher_user(stubs={})
    @mock_publisher_user ||= mock_model(User, stubs.merge(:role => 'publisher'))
  end

  def mock_settings(stubs={})
    @mock_settings ||= mock_model(Settings, stubs.merge(:location => stubs[:location] || mock_location) )
  end

  def mock_location(stubs={})
    @mock_location ||= mock_model(Location, stubs.merge(:world? => stubs[:world?] || true))
  end

  def valid_params
    {
      :project_id => "1",
      :event => {
        :title => "Testing Event from Berlin",
        :description => "Donec sed odio dui. Fusce dapibus.",
        :geom => "POINT(68.36646999999994 25.38019 0)",
        :address => "Hyderabad, Pakistan",
        :sector_tokens => "1,2",
        :partner_tokens => "2,1"
      }
    }
  end

  describe "publisher user" do
    before(:each) do
      # sign_in mock_user
      request.env['warden'] = mock( Warden,
                                    :authenticate  => mock_publisher_user(:id => "1"),
                                    :authenticate! => mock_publisher_user(:id => "1"))
    end

    describe "GET index" do
      it "assigns all events as @events" do
        Project.stub(:find).with("1") { mock_project }
        Project.stub(:find) { mock_project(:events => [mock_event]) }

        get :index, :project_id => "1"
        assigns(:events).should eq([mock_event])
        assigns(:project).should be(mock_project)
      end
    end

    describe "GET show" do
      it "assigns the requested event as @event and project as @project" do
        Project.stub(:find).with("1") { mock_project }
        mock_project.stub_chain(:events, :find).with("37"){ mock_event }

        get :show, :id => "37", :project_id => "1"
        assigns(:event).should be(mock_event)
        assigns(:project).should be(mock_project)
      end
    end

    describe "GET new" do
      it "assigns new event as @event and requested project as @project" do
        Project.stub(:find).with("1") { mock_project }
        Event.stub(:new) { mock_event }

        get :new, "project_id" => "1", :user_id => "1"

        assigns(:project).should be(mock_project)
        assigns(:event).should be(mock_event)
      end
    end

    describe "GET edit" do
      it "assigns the requested event as @event" do
        Project.stub(:find).with("1") { mock_project }
        mock_project.stub_chain(:events, :find).with("37"){ mock_event }
        mock_event.stub(:user_id){"1"} # for CanCan Ability.rb

        get :edit, :id => "37", :project_id => "1", :user_id => "1"
        assigns(:event).should be(mock_event)
        assigns(:project).should be(mock_project)
      end
    end

    describe "POST create" do
      before(:each) do
        # sign_in mock_user
        request.env['warden'] = mock( Warden,
                                      :authenticate  => mock_admin_user(:settings => mock_settings),
                                      :authenticate! => mock_admin_user(:settings => mock_settings))
      end

      describe "with valid params" do
        it "assigns a newly created event as @event" do
          geom = Point.from_ewkt(valid_params[:event][:geom])
          Project.stub(:find).with("1") { mock_project }
          mock_event.stub(:geom=).with(geom){ geom }
          mock_event.stub(:user=).with(mock_admin_user){ mock_admin_user }
          mock_project.stub_chain(:events, :build){ mock_event.as_new_record }
          mock_event.stub(:save).and_return(true)
          mock_event.stub(:as_feature_hash)

          post :create, valid_params
          assigns(:event).should be_a(Event)
          response.should be_redirect
        end

        it "redirects to the project of the created event"
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested event"
        it "assigns the requested event as @event"
        it "redirects to the event"
      end

      describe "with invalid params" do
        it "assigns the event as @event"
        it "re-renders the 'edit' template"
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested event"
      it "redirects to the events list"
    end

  end

  # TODO:
  # TODO: add test for admin users
  # TODO: add test for guest users

end
