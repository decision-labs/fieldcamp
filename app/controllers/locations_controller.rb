class LocationsController < ApplicationController

  respond_to :mobile, :html
  before_filter :set_desired_columns

  def index
    if current_user
      # TODO ensure geom is not included with the children
      @locations = Location.where(:id => current_user_location_ids).includes(:children).select(@desired_columns).page(params[:page]).order('admin_level asc').all
    end
  end

  def show
    @location ||= Location.find(params[:id])
    respond_to do |format|
      format.html{
        @projects ||= @location.child_projects.all(:include => :events)
      }
      format.json  {
        # CHECK: if doing ajax is faster than using the cached geometry (see routes.rb)
        # if params[:events]
        #   @projects ||= @location.child_projects.all(:include => :events)
        #   render(:layout => false, :json => Project.events_to_feature_collection(@projects))
        # else
        #   render(:layout => false, :json => @location.geom.as_geojson)
        # end
        redis ||= REDIS
        key = "location:"+@location.id.to_s
        if redis.exists(key)
          geojson = redis.get(key)
        else
          unless @location.admin_level == 0
            geojson =  @location.geom.as_json
          else
            # TODO FIXME: think of a better way to simplify on serverside (perhaps a second simple_geom column)
            res = ActiveRecord::Base.connection.execute(
                    "SELECT ST_AsGeoJson(ST_Simplify(geom, 0.1)) geom from locations where locations.id = #{@location.id}")
            geojson = res[0]["geom"]
          end
          redis.setex(key, 1800, geojson)
        end
        render(:layout => false, :json => geojson)
      }
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
    redis ||= REDIS

    respond_to do |format|
      if @location.update_attributes(params[:location])
        redis.del("location:"+@location.id.to_s)
        format.html { redirect_to(@location, :notice => 'Location was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    authorize! :destroy, Location
    redis ||= REDIS
    @location = Location.find(params[:id], :select => @desired_columns)
    redis.del("location:"+@location.id.to_s)
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
