class ProjectsController < ApplicationController

  def index
    @projects = Project.all
    authorize! :index, @projects

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  def show
    @project = Project.find(params[:id], :include => [:location, :events])
    authorize! :show, @project

    respond_to do |format|
      format.html # show.html.erb
      format.json  { render(:layout => false, :json => @project.location.geom.as_geojson) }
    end
  end

  def new
    @project = Project.new
    authorize! :new, @project

    respond_to do |format|
      format.html # new.html.erb
      format.mobile
    end
  end

  def edit
    @project = Project.find(params[:id])
    authorize! :edit, @project
  end

  def create
    @project = Project.new(params[:project])
    @project.sectors  << Sector.find( params[:sectors] ) rescue []
    @project.partners << Partner.find(params[:partners]) rescue []
    authorize! :create, @project

    respond_to do |format|
      if @project.save
        format.html { redirect_to(@project, :notice => 'Project was successfully created.') }
        format.mobile  { redirect_to(@project, :notice => 'Project was successfully created.') }
      else
        format.html { render :action => "new" }
        format.mobile { render :action => "new" }
      end
    end
  end

  def update
    @project = Project.find(params[:id])
    authorize! :update, @project

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.mobile { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.mobile { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.find(params[:id])
    authorize! :destroy, @project

    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
end
