class Project < ActiveRecord::Base
  belongs_to :location, :counter_cache => true
  belongs_to :user
  has_many :events, :dependent => :destroy
  has_many :articles, :dependent => :destroy

  validate :title, :presence => true
  validate :description, :presence => true
  validate :start_date, :presence => true
  validate :end_date, :presence => true
  validate :location_id, :presence => true
  validates_numericality_of :location_id, :message => "is not valid"

  has_and_belongs_to_many :sectors
  has_and_belongs_to_many :partners

  # To avoid sending geometry data when all tokenizer needs is :id and :name
  def location_token
    l = Location.where(:id => location_id).select([:id, :name]).all
    l.blank? ? {} : l.map(&:attributes)
  end

  # TODO: bad smell
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
