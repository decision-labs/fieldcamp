class SearchController < ApplicationController
  def index
    @projects = nil
    if !params[:search].blank?
      @projects = Project.search(params[:search][:project],params[:search][:location])
    end
  end

  def locations
    unless params[:q].blank?
      locations = Location.search(params[:q])
      results = locations.as_json.collect{|l| l["location"]}
      render :json => results.to_json
    else
      render :json => {}
    end
  end

end
