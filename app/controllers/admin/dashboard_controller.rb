class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    @events = current_user.events_since_login.
      order('created_at DESC').
      paginate(:page => params[:page], :per_page => 5).all
    @projects = Project.where(:id => @events.map(&:project_id).uniq)

    # TODO: move to models
    # @recent_projects  = Project.find(:all, :order => "id desc", :limit => 5)
    # @recent_events    = Event.find(:all, :order => "id desc", :limit => 5)
    # @recent_sectors   = Sector.find(:all, :order => "id desc", :limit => 5)
    # @recent_partners  = Partner.find(:all, :order => "id desc", :limit => 5)
    @countries ||= Location.countries.select([:id, :name, :child_location_ids])
    @countries_attributes = @countries.collect{ |c| c.attributes.merge(:total_projects => c.total_projects(:include_children => true)) }
  end
end
