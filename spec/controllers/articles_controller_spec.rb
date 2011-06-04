require 'spec_helper'

describe ArticlesController do
  include Devise::TestHelpers

  before :each do
    @article = Article.make
    @author  = @article.author
    sign_in @author
  end

  def valid_attributes
    { :published_at => 2.days.from_now,
      :content => @article.content }
  end

  describe "GET index" do
    it "assigns all articles as @articles" do
      get :index
      assigns(:articles).should include(@article)
    end
  end

  describe "GET show" do
    it "assigns the requested article as @article" do
      get :show, :id => @article.id.to_s
      assigns(:article).should eq(@article)
    end
  end

  describe "GET new" do
    it "assigns a new article as @article" do
      get :new
      assigns(:article).should be_a_new(Article)
    end
  end

  describe "GET edit" do
    it "assigns the requested article as @article" do
      get :edit, :id => @article.id.to_s
      assigns(:article).should eq(@article)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Article" do
        expect {
          post :create, :article => valid_attributes
        }.to change(Article, :count).by(1)
      end

      it "assigns a newly created article as @article" do
        post :create, :article => valid_attributes
        assigns(:article).should be_a(Article)
        assigns(:article).should be_persisted
      end

      it "redirects to the created article" do
        post :create, :article => valid_attributes
        response.should redirect_to(Article.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved article as @article" do
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        post :create, :article => {}
        assigns(:article).should be_a_new(Article)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        post :create, :article => {}
        response.should render_template("new")
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested article" do
          Article.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => @article.id, :article => {'these' => 'params'}
        end

        it "assigns the requested article as @article" do
          put :update, :id => @article.id, :article => valid_attributes
          assigns(:article).should eq(@article)
        end

        it "redirects to the article" do
          put :update, :id => @article.id, :article => valid_attributes
          response.should redirect_to(@article)
        end
      end

      describe "with invalid params" do
        it "assigns the article as @article" do
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          put :update, :id => @article.id.to_s, :article => {}
          assigns(:article).should eq(@article)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Article.any_instance.stub(:save).and_return(false)
          put :update, :id => @article.id.to_s, :article => {}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested article" do
        expect {
          delete :destroy, :id => @article.id.to_s
        }.to change(Article, :count).by(-1)
      end

      it "redirects to the articles list" do
        delete :destroy, :id => @article.id.to_s
        response.should redirect_to(articles_url)
      end
    end
  end
end
