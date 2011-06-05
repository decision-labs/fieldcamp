class ArticlesController < ApplicationController
  # GET /articles
  # GET /articles.xml

  before_filter :authorize
  before_filter :set_project
  before_filter :set_author

  def index
    @articles = if current_user.admin?
                  @project.articles
                else
                  @project.articles.where(:author_id => current_user.id)
                end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @articles }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @article = @project.articles.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    @article = current_user.articles.build(:project_id => @project.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @article }
    end
  end

  # GET /articles/1/edit
  def edit
    @article = @project.articles.find(params[:id])
    authorize! :edit, @article
  end

  # POST /articles
  # POST /articles.xml
  def create
    @article = @project.articles.build(params[:article])
    @article.author = current_user
    respond_to do |format|
      if @article.save
        format.html { redirect_to([@project,@article], :notice => 'Article was successfully created.') }
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
    @article = @project.articles.find(params[:id])
    authorize! :edit, @article
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to([@project,@article],
                                  :notice => 'Article was successfully updated.') }
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
    @article = @project.articles.find(params[:id])
    authorize! :destroy, @article
    @article.destroy

    respond_to do |format|
      format.html { redirect_to([@project,:articles]) }
      format.xml  { head :ok }
    end
  end

  def authorize
    unauthorized! unless current_user
  end
  private :authorize

  def set_project
    @project = Project.find(params[:project_id])
  end
  private :set_project

  def set_author
    params[:article].merge!({:author_id => @current_user.id}) if params[:article]
  end
  private :set_author
end
