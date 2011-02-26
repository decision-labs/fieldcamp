class SectorsController < ApplicationController

  respond_to :mobile, :html

  def index
    @sectors = Sector.all(:include => :projects)
  end

  def show
    @sector = Sector.find(params[:id], :include => :projects)
  end

  def new
    @sector = Sector.new
  end

  # GET /sectors/1/edit
  def edit
    @sector = Sector.find(params[:id])
  end

  # POST /sectors
  # POST /sectors.xml
  def create
    @sector = Sector.new(params[:sector])

    respond_to do |format|
      if @sector.save
        format.html { redirect_to(@sector, :notice => 'Sector was successfully created.') }
        format.xml  { render :xml => @sector, :status => :created, :location => @sector }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sector.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sectors/1
  # PUT /sectors/1.xml
  def update
    @sector = Sector.find(params[:id])

    respond_to do |format|
      if @sector.update_attributes(params[:sector])
        format.html { redirect_to(@sector, :notice => 'Sector was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sector.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sectors/1
  # DELETE /sectors/1.xml
  def destroy
    @sector = Sector.find(params[:id])
    @sector.destroy

    respond_to do |format|
      format.html { redirect_to(sectors_url) }
      format.xml  { head :ok }
    end
  end
end
