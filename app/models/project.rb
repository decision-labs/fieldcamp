class Project < ActiveRecord::Base
  belongs_to :location, :counter_cache => true
  belongs_to :user
  has_many :events, :dependent => :destroy
  has_many :articles, :dependent => :destroy

  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :partners

  validates_presence_of :title

  # def self.user_location_scoped(location_ids)
  #   scope :all, where(:location_id => location_ids)
  # end

  # {
  #     :type => "FeatureCollection",
  #     :features => @events.map(&:as_feature_hash)
  # }
  def self.events_to_feature_collection(projects)
    features = []
    projects.each{ |project| features.concat(Event.events_to_feature_collection(project.events)) }

    {
      :type => "FeatureCollection",
      :features => features
    }
  end
  
  def self.search(query, location='')

    # TODO: Refactor like mad!
      if !query.blank? && !location.blank?
      conditions = <<-EOS
        to_tsvector('english',
          coalesce(projects.title, '') || ' ' ||  coalesce(projects.description, '' )
        ) @@ plainto_tsquery('english', ?) 
        AND
        to_tsvector('english', 
          coalesce(locations.name, '')
        ) @@ plainto_tsquery('english', ?) 
      EOS
      joins(:location).where(conditions, query, location)

    elsif !location.blank?
      conditions = <<-EOS
        to_tsvector('english', 
          coalesce(locations.name, '')
        ) @@ plainto_tsquery('english', ?) 
      EOS
      joins(:location).where(conditions, location)

    elsif !query.blank?
      conditions = <<-EOS
        to_tsvector('english',
          coalesce(projects.title, '') || ' ' ||  coalesce(projects.description, '' )
        ) @@ plainto_tsquery('english', ?) 
      EOS
      where(conditions, query)
    end

  end

end
