require 'spec_helper'

describe ArticlesController do
  include Devise::TestHelpers
  render_views

  before :each do
    @another_article = Article.make
    @article = Article.make
    @author  = @article.author
    sign_in @author
  end

  def valid_attributes
    { :published_at => 2.days.from_now,
      :content => @article.content,
      :project_id => @article.project_id }
  end

  describe "GET index" do
    it "assigns owned articles as @articles" do
      get :index
      assigns(:articles).should include(@article)
    end

    it "doesn't assign articles I do not own" do
      get :index
      assigns(:articles).should_not include(@another_article)
    end

    it "should display all articles for admins" do
      sign_in User.make(:role => "admin")
      get :index
      assigns(:articles).should include(@article)
      assigns(:articles).should include(@another_article)
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
      get :new, :project_id => @article.project_id
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
        post :create, :article => {:project_id => @article.project_id}
        assigns(:article).should be_a_new(Article)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Article.any_instance.stub(:save).and_return(false)
        post :create, :article => {:project_id => @article.project_id}
        response.should render_template("new")
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested article" do
          put :update, :id => @article.id, :article => {:content => 'new content'}
          Article.find(@article.id).content.should == "new content"
        end

        it "assigns the requested article as @article" do
          put :update, :id => @article.id, :article => valid_attributes
          assigns(:article).should eq(@article)
        end

        it "redirects to the article" do
          put :update, :id => @article.id, :article => valid_attributes
          response.should redirect_to(@article)
        end

        it "saves draft" do
          put :update, :id => @article.id, :article => valid_attributes
          response.should redirect_to(@article)
          @article.should be_a_draft
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

    describe "PUT unpublish" do
      it "unpublishes an article" do
        @article.publish
        @article.should be_published
        put :unpublish, :id => @article.id.to_s

        @article.reload
        @article.should_not be_published
        @article.should be_a_draft
      end
    end
  end
end
