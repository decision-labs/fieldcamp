class PartnersController < ApplicationController

  respond_to :mobile, :html

  def index
    @partners = Partner.all(:include => :projects, :order => 'created_at desc')
  end

  def show
    @partner = Partner.find(params[:id], :include => :projects)
  end

  def new
    authorize! :new, Partner
    @partner = Partner.new
  end

  def edit
    authorize! :edit, Partner
    @partner = Partner.find(params[:id])
  end

  def create
    authorize! :create, Partner
    @partner = Partner.new(params[:partner])
    @partner.user = current_user

    respond_to do |format|
      if @partner.save
        format.html { redirect_to(@partner, :notice => 'Partner was successfully created.') }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    authorize! :update, Partner
    @partner = Partner.find(params[:id])

    respond_to do |format|
      if @partner.update_attributes(params[:partner])
        format.html { redirect_to(@partner, :notice => 'Partner was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    authorize! :destroy, Partner
    @partner = Partner.find(params[:id])
    @partner.destroy

    respond_to do |format|
      format.html { redirect_to(partners_url) }
    end
  end
end
