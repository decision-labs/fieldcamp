class SearchController < ApplicationController
  # FIXME: later refactor to Search::BaseController with Search::{Projects,Sectors,Partners}Controller

  def index
    @projects = nil
    if !params[:search].blank?
      @projects = Project.search(params[:search][:project],params[:search][:location])
    end
  end

  def locations
    unless params[:q].blank?
      params.merge!(:user_location_id => current_user.settings.location_id) unless params[:change_settings]
      results = Location.search(params)
      render :json => results.to_json
    else
      render :json => {}
    end
  end

  def sectors
    unless params[:q].blank?
      q = params[:q]
      results = Sector.where("LOWER(name) LIKE ?", "%#{q.downcase}%")
      render :json => results.map(&:attributes)
    else
      render :json => {}
    end
  end

  def partners
    unless params[:q].blank?
      q = params[:q]
      results = Partner.where("LOWER(name) LIKE ?", "%#{q.downcase}%")
      render :json => results.map(&:attributes)
    else
      render :json => {}
    end
  end

  def projects
    flash.delete(:notice)
    @project_search = ProjectSearch.new(params)
    unless @project_search.results.nil?
      if @project_search.results.empty?
        flash[:notice] = t('no_results_found') + " <a href='#{search_path}'>try another</a>"
      elsif
        flash[:notice] = "<a href='#{request.fullpath}'>" + t('n_results_found', :n => @project_search.results.size) + "</a>"
      end
    end
  end
end
