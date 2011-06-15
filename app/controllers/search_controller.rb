class SearchController < ApplicationController
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
    @results = nil
    l = {}
    s = {}
    p = {}
    if !params[:search].blank?

      if !params[:search][:location_ids].blank?
        location_ids = params[:search][:location_ids].split(',').map(&:to_i)
        # parent locations:
        parent_location_ids  = Location.where{id.in(location_ids)}.select{id}
        # child locations:
        child_location_ids  = Location.where{parent_id.in(parent_location_ids) }.select{id} + parent_location_ids
        l = Project.where{location_id.in(child_location_ids)}
      end

      if !params[:search][:sector_ids].blank?
        sector_ids = params[:search][:sector_ids].split(',').map(&:to_i)
        sectors  = Sector.where{id.in(sector_ids)}
        s = Project.joins{:sectors}.where{ projects_sectors.sector_id.in(sectors.select{id}) }
      end

      if !params[:search][:partner_ids].blank?
        partner_ids = params[:search][:partner_ids].split(',').map(&:to_i)
        partners  = Partner.where{id.in(partner_ids)}
        p = Project.joins{:partners}.where{ partners_projects.partner_id.in(partners.select{id}) }
      end

      # @results = Project.where{location_id.in(child_location_ids)}
      # TODO fix don't do permutations!

      if( p != {} && s != {} && l != {})
        @results = (p & s & l).all 
      elsif p != {} && s != {} && l == {}
        @results = (p & s).all
      elsif p != {} && s == {} && l != {}
        @results = (p & l).all 
      elsif p == {} && s != {} && l != {}
        @results = (s & l).all 
      elsif p != {} && s == {} && l == {}
        @results = (p).all
      elsif p == {} && s != {} && l == {}
        @results = (s).all
      elsif p == {} && s == {} && l != {}
        @results = (l).all
      elsif p == {} && s == {} && l == {}
        @results
      else
        @results
      end
    end
  end
end
