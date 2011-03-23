class SectorsController < ApplicationController

  respond_to :mobile, :html

  def index
    if session[:sectors_sort_order].blank? && params[:sort_order].blank?
      session[:sectors_sort_order] = 'sectors.updated_at desc'
    elsif !params[:sort_order].blank? && (session[:sectors_sort_order] != params[:sort_order])
      session[:sectors_sort_order] = params[:sort_order]
    end

    if current_user
      @sectors = Sector.all(:include => :projects,
        :conditions => {"projects.location_id" => @current_user_location_ids},
        :order => session[:sectors_sort_order])
    else
      @sectors = Sector.all(:include => :projects, :order => session[:sectors_sort_order])
    end
  end

  def show
    if current_user
      @sector = Sector.find(params[:id],
        :include => :projects,
        :conditions => {"projects.location_id" => @current_user_location_ids})
    else
      @sector = Sector.find(params[:id], :include => :projects)
    end
  end

  def new
    authorize! :new, Sector
    @sector = Sector.new
  end

  def edit
    authorize! :edit, Sector
    @sector = Sector.find(params[:id])
  end

  def create
    authorize! :create, Sector
    @sector = Sector.new(params[:sector])
    @sector.user = current_user

    respond_to do |format|
      if @sector.save
        format.html { redirect_to(@sector, :notice => 'Sector was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    authorize! :update, Sector
    @sector = Sector.find(params[:id])

    respond_to do |format|
      if @sector.update_attributes(params[:sector])
        format.html { redirect_to(@sector, :notice => 'Sector was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    authorize! :destroy, Sector
    @sector = Sector.find(params[:id])
    @sector.destroy

    respond_to do |format|
      format.html { redirect_to(sectors_url) }
    end
  end
end
