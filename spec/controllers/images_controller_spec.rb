require 'spec_helper'

describe ImagesController do
  include Devise::TestHelpers
  render_views

  before :each do
    sign_in User.make
  end

  def valid_attributes
    { :title => "image title",
      :asset => File.open(File.join(Rails.root,"spec","fixtures","rails.png")) }
  end

  describe "GET index" do
    it "assigns all images as @images" do
      image = Image.create! valid_attributes
      get :index
      assigns(:images).should include(image)
    end
  end

  describe "GET show" do
    it "assigns the requested image as @image" do
      image = Image.create! valid_attributes
      get :show, :id => image.id.to_s
      assigns(:image).should eq(image)
    end
  end

  describe "GET new" do
    it "assigns a new image as @image" do
      get :new
      assigns(:image).should be_a_new(Image)
    end
  end

  describe "GET edit" do
    it "assigns the requested image as @image" do
      image = Image.create! valid_attributes
      get :edit, :id => image.id.to_s
      assigns(:image).should eq(image)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Image" do
        expect {
          post :create, :image => valid_attributes
        }.to change(Image, :count).by(1)
      end

      it "assigns a newly created image as @image" do
        post :create, :image => valid_attributes
        assigns(:image).should be_a(Image)
        assigns(:image).should be_persisted
      end

      it "redirects to the created image" do
        post :create, :image => valid_attributes
        response.should redirect_to(Image.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved image as @image" do
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        post :create, :image => {}
        assigns(:image).should be_a_new(Image)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        post :create, :image => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested image" do
        image = Image.create! valid_attributes
        # Assuming there are no other images in the database, this
        # specifies that the Image created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Image.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => image.id, :image => {'these' => 'params'}
      end

      it "assigns the requested image as @image" do
        image = Image.create! valid_attributes
        put :update, :id => image.id, :image => valid_attributes
        assigns(:image).should eq(image)
      end

      it "redirects to the image" do
        image = Image.create! valid_attributes
        put :update, :id => image.id, :image => valid_attributes
        response.should redirect_to(image)
      end
    end

    describe "with invalid params" do
      it "assigns the image as @image" do
        image = Image.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        put :update, :id => image.id.to_s, :image => {}
        assigns(:image).should eq(image)
      end

      it "re-renders the 'edit' template" do
        image = Image.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Image.any_instance.stub(:save).and_return(false)
        put :update, :id => image.id.to_s, :image => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested image" do
      image = Image.create! valid_attributes
      expect {
        delete :destroy, :id => image.id.to_s
      }.to change(Image, :count).by(-1)
    end

    it "redirects to the images list" do
      image = Image.create! valid_attributes
      delete :destroy, :id => image.id.to_s
      response.should redirect_to(images_url)
    end
  end
end
