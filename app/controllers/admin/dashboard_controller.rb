class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    @projects = current_user.events_since_login.limit(5).group_by(&:project_id)

    @has_more_events = current_user.events_since_login.count > 5

    # TODO: move to models
    # @recent_projects  = Project.find(:all, :order => "id desc", :limit => 5)
    # @recent_events    = Event.find(:all, :order => "id desc", :limit => 5)
    # @recent_sectors   = Sector.find(:all, :order => "id desc", :limit => 5)
    # @recent_partners  = Partner.find(:all, :order => "id desc", :limit => 5)
  end
end
