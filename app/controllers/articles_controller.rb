class ArticlesController < ApplicationController

  before_filter :authorize

  # GET /articles
  # GET /articles.xml
  def index
    @articles = if current_user.admin?
                  Article.all
                else
                  current_user.articles.all
                end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = current_user.articles.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = current_user.articles.build(:project_id => params[:project_id])
    @project = Project.find(@article.project_id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = current_user.articles.find(params[:id])
    @project = @article.project
    authorize! :edit, @article
  end

  # POST /articles
  # POST /articles.xml
  def create
    params[:article][:published] = true if params[:article][:published]
    authorize! :create, Article
    @article = current_user.articles.build(params[:article])
    @project = Project.find(@article.project_id)

    respond_to do |format|
      if @article.save
        format.html { redirect_to(@article, :notice => 'Article was successfully created.') }
        format.xml  { render :xml => @article, :status => :created, :location => @article }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @article = current_user.articles.find(params[:id])
    @project = @article.project
    authorize! :edit, @article

    params[:article][:published] = true if params[:article][:published]

    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to(@article, :notice => 'Article was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @article = current_user.articles.find(params[:id])
    authorize! :destroy, @article
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(:articles) }
      format.xml  { head :ok }
    end
  end

  def projects
    @projects = Project.order('created_at desc').paginate(:page => params[:page], :per_page => 5).all
  end

  def unpublish
    @article = current_user.articles.find(params[:id])

    respond_to do |format|
      if @article.unpublish!
        format.html { redirect_to(@article, :notice => 'Article was successfully unpublished.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @article.errors, :status => :unprocessable_entity }
      end
    end
  end

  def authorize
    unauthorized! unless current_user
  end
  private :authorize

end
