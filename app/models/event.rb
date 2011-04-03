class Event < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_presence_of :title, :message => "Title can't be blank."
  validates_with EventAddressValidator

  scope :desc, order("events.updated_at DESC")

  def as_feature_hash
    props = attributes # todo change the description to html
    props["description"] = RDiscount.new(attributes["description"]).to_html if !attributes["description"].nil?
    props.delete('geom')
    geojson = {
      :id => to_param,
      :type => 'Feature',
      :properties => props,
      :geometry => JSON.parse(geom.as_geojson)
    }
    geojson
  end

  def to_param
    [id, title.parameterize].join('-')
  end

  # return array of feature arrays
  def self.events_to_feature_collection(events_collection)
    events_collection.map(&:as_feature_hash)
  end

end
