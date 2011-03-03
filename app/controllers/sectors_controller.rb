class SectorsController < ApplicationController

  respond_to :mobile, :html

  def index
    @sectors = Sector.all(:include => :projects)
  end

  def show
    @sector = Sector.find(params[:id], :include => :projects)
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
