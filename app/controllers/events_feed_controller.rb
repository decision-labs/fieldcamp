class EventsFeedController < ApplicationController
  def index
    @events = Event.joins(:project).where('projects.location_id' => @current_user_location_ids).order('created_at desc').page(params[:page]).per(5)
  end
end
