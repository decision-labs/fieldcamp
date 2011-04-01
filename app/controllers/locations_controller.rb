class LocationsController < ApplicationController

  respond_to :mobile, :html
  before_filter :set_desired_columns

  def index
    if current_user
      @locations = current_user.settings.location.children.paginate(
        :per_page => 5,
        :page => params[:page],
        :select => @desired_columns,
        :order  => 'locations.created_at desc')
      @locations.insert(0, Location.find(current_user.settings.location.id, :select => @desired_columns))
    else
      @locations = Location.paginate(
        :per_page => 5,
        :page => params[:page],
        :select => @desired_columns,
        :order  => 'locations.created_at desc')
    end
  end

  def show
    @location = Location.find(params[:id], :include => :projects)
    respond_to do |format|
      format.html
      format.json  { render(:layout => false, :json => @location.geom.as_geojson) }
    end
  end

  def new
    authorize! :new, Location
    @location = Location.new
  end

  def edit
    authorize! :edit, Location
    @location = Location.find(params[:id], :select => @desired_columns)
  end

  def create
    authorize! :create, Location
    @location = Location.new(params[:location])
    @location.user = current_user

    respond_to do |format|
      if @location.save
        format.html { redirect_to(@location, :notice => 'Location was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    authorize! :update, Location
    @location = Location.find(params[:id], :select => @desired_columns)

    respond_to do |format|
      if @location.update_attributes(params[:location])
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    authorize! :destroy, Location
    @location = Location.find(params[:id], :select => @desired_columns)
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
    end
  end

  private
  def set_desired_columns
    @desired_columns = (Location.column_names - ['geom']).join(', ')
  end
end
