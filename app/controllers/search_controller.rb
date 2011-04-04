class SearchController < ApplicationController
  def index
    @projects = nil
    if !params[:search].blank?
      @projects = Project.search(params[:search][:project],params[:search][:location])
    end
  end
end
