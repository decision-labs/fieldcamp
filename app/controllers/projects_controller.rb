class ProjectsController < ApplicationController

  respond_to :mobile, :html

  def index
    @projects = Project.all(:order => 'created_at desc')
  end

  def show
    @project = Project.find(params[:id], :include => [:location, :events])
    respond_to do |format|
      format.html
      format.json  { render(:layout => false, :json => @project.location.geom.as_geojson) }
    end
  end

  def new
    authorize! :new, Project
    @project = Project.new
  end

  def edit
    authorize! :edit, Project
    @project = Project.find(params[:id])
  end

  def create
    authorize! :create, Project
    @project = Project.new(params[:project])
    @project.sectors  << Sector.find(params[:sectors])   rescue []
    @project.partners << Partner.find(params[:partners]) rescue []
    @project.user = current_user

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
    authorize! :update, Project
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to(@project, :notice => 'Project was successfully updated.') }
        format.mobile { redirect_to(@project, :notice => 'Project was successfully updated.') }
      else
        format.html { render :action => "edit" }
        format.mobile { render :action => "edit" }
      end
    end
  end

  def destroy
    authorize! :destroy, Project
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
    end
  end
end
