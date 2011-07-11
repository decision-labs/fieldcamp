class ProjectsController < ApplicationController

  respond_to :mobile, :html
  before_filter :set_desired_columns
  before_filter :set_locations, :only => [:new, :edit, :update, :create]

  def index
    if params[:sort_order].blank? && session[:projects_sort_order].blank?
      session[:projects_sort_order] = 'created_at desc'
    elsif !params[:sort_order].blank? && (params[:sort_order] != session[:projects_sort_order])
      session[:projects_sort_order] = params[:sort_order]
    end

    if current_user
      #FIXME: Dry this branching
      unless @current_user_location_ids.blank?
        @projects = Project.all(
          :conditions => {'projects.location_id' => @current_user_location_ids},
          :order => session[:projects_sort_order])
      else
        @projects = Project.all(:order => session[:projects_sort_order])
      end
    else
      @projects = Project.all(:order => session[:projects_sort_order])
    end

  end

  def show
    if current_user
      #FIXME: Dry this branching, also in view we iterate over all projects again to find events.
      unless @current_user_location_ids.blank?
        @project = Project.find(params[:id], :include => [:location, :events],
          :conditions => {'projects.location_id' => @current_user_location_ids})
      else
        @project = Project.find(params[:id], :include => [:location, :events])
      end
    else
      @project = Project.find(params[:id], :include => [:location, :events])
    end

    respond_to do |format|
      format.html
      format.json {
        redis ||= REDIS
        key = "location:"+@project.location.id.to_s
        if redis.exists(key)
          geojson = redis.get(key)
        else
          geojson =  @project.location.geom.as_geojson
          redis.setex(key, 1800, geojson)
        end
        render(:layout => false, :json => geojson) 
      }
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

    params[:project][:partner_ids] ||= []
    params[:project][:sector_ids] ||= []

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

  private
  def set_desired_columns
    @desired_columns = (Location.column_names - ['geom']).join(', ')
  end

  def set_locations
    @locations = current_user.settings.location.children.all(:select => @desired_columns, :order => 'locations.name')
    @locations.insert(0, Location.find(current_user.settings.location.id, :select => @desired_columns))
  end
end
