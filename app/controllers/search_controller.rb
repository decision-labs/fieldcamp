class SearchController < ApplicationController
  # TODO: later refactor to Search::BaseController with Search::{Projects,Sectors,Partners}Controller
  def new
    # render new
  end

  def index
    @projects = nil
    if !params[:search].blank?
      @projects = Project.search(params[:search][:project],params[:search][:location])
    end
  end

  def locations
    unless params[:q].blank?
      results = Location.search(params[:q])
      render :json => results.to_json
    else
      render :json => {}
    end
  end

  def sectors
    unless params[:q].blank?
      q = params[:q]
      results = Sector.find_by_sql "SELECT * FROM sectors WHERE (LOWER(name) LIKE \'%#{q.downcase}%\')"
      render :json => results.map(&:attributes)
    else
      render :json => {}
    end
  end

  def partners
    unless params[:q].blank?
      q = params[:q]
      results = Partner.find_by_sql "SELECT * FROM partners WHERE (LOWER(name) LIKE \'%#{q.downcase}%\')"
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
        flash[:notice] = t('no_results_found')
      elsif
        flash[:notice] = t('n_results_found', :n => @project_search.results.size)
      end
    end
  end
end
