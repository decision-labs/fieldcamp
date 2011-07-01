class ProjectSearch
  attr_reader :results, :params, :tokens

  def initialize(params={})
    @params = Hash.new.merge(params || {}).symbolize_keys!
    @tokens = {:locations => {}, :partners => {}, :sectors => {}}
    @results = nil
    l = {}
    s = {}
    p = {}
    if !@params[:search].blank?
      if !@params[:search][:location_ids].blank?
        location_ids = @params[:search][:location_ids].split(',').map(&:to_i)
        # parent locations:
        parent_location_ids  = Location.where{id.in(location_ids)}.select{id}
        @tokens[:locations] = Location.where{id.in(parent_location_ids)}.select{[id, name]}.map(&:attributes)
        # child locations:
        all_location_ids  = Location.where{parent_id.in(parent_location_ids) }.select{id} + parent_location_ids
        l = Project.where{location_id.in(all_location_ids)}
      end

      if !@params[:search][:sector_ids].blank?
        sector_ids = @params[:search][:sector_ids].split(',').map(&:to_i)
        sectors  = Sector.where{id.in(sector_ids)}
        @tokens[:sectors] = sectors.select{[id, name]}.map(&:attributes)
        s = Project.joins{:sectors}.where{ projects_sectors.sector_id.in(sectors.select{id}) }
      end

      if !@params[:search][:partner_ids].blank?
        partner_ids = @params[:search][:partner_ids].split(',').map(&:to_i)
        partners  = Partner.where{id.in(partner_ids)}
        @tokens[:partners] = partners.select{[id, name]}.map(&:attributes)
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
        @results = []
      end
    end
  end

end