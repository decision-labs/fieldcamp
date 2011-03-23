class PartnersController < ApplicationController

  respond_to :mobile, :html

  def index
    if session[:partners_sort_order].blank? && params[:sort_order].blank?
      session[:partners_sort_order] = 'partners.updated_at desc'
    elsif !params[:sort_order].blank? && (session[:partners_sort_order] != params[:sort_order])
      session[:partners_sort_order] = params[:sort_order]
    end

    if current_user
      @partners = Partner.all(:include => :projects,
        :conditions => {"projects.location_id" => @current_user_location_ids},
        :order => session[:partners_sort_order])
    else
      @partners = Partner.all(:include => :projects, :order => session[:partners_sort_order])
    end
  end

  def show
    if current_user
      @partner = Partner.find(params[:id], :include => :projects,
        :conditions => {"projects.location_id" => @current_user_location_ids},
        :order => 'partners.created_at desc')
    else
      @partner = Partner.find(params[:id], :include => :projects)
    end

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
