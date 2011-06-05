class Admin::DashboardController < ApplicationController
  before_filter :authenticate_user!
  def index
    @projects = current_user.events_since_login.group_by(&:project_id)
  end
end
