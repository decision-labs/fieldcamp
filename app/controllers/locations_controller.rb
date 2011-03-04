class LocationsController < ApplicationController

  respond_to :mobile, :html

  def index
    @locations = Location.all(:include => :projects, :order => 'created_at desc')
  end

  def show
    @location = Location.find(params[:id], :include => :projects)
  end

  def new
    authorize! :new, Location
    @location = Location.new
  end

  def edit
    authorize! :edit, Location
    @location = Location.find(params[:id])
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
    @location = Location.find(params[:id])

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
    @location = Location.find(params[:id])
    @location.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
    end
  end
end
