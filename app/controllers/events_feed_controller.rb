class EventsFeedController < ApplicationController
  def index

    #FIXME: Dry this branching
    unless @current_user_location_ids.blank?
      @events = Event.joins(:project).where(
        'projects.location_id' => @current_user_location_ids
      ).order('created_at desc').page(params[:page]).per(5)
    else
      @events = Event.joins(:project).order('created_at desc').page(params[:page]).per(5)
    end

  end
end
