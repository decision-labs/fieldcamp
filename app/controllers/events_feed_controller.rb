class EventsFeedController < ApplicationController
  def index

    #FIXME: Dry this branching
    unless current_user_location_ids.blank?
      @events = Event.joins(:project).where(
        'projects.location_id' => current_user_location_ids
      ).order('created_at desc').paginate(:page => params[:page], :per_page => 5)
    else
      @events = Event.joins(:project).order('created_at desc').paginate(:page => params[:page], :per_page => 5)
    end

  end
end
