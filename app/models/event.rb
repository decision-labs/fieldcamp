class Event < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_one :location, :through => :project
  has_many :images, :dependent => :destroy
  has_and_belongs_to_many :partners
  has_and_belongs_to_many :sectors

  accepts_nested_attributes_for :images, :allow_destroy => true,  :reject_if => :all_blank

  validates_presence_of :title, :message => "Title can't be blank."
  validates_with EventAddressValidator

  scope :desc, order("events.updated_at DESC")

  attr_accessible :title, :description, :address, :project_id, :partner_ids, :sector_ids, :images_attributes

  def as_feature_hash
    props = attributes
    props["description"] = RDiscount.new(attributes["description"]).to_html if !attributes["description"].nil?
    props["updated_at"] = attributes["updated_at"].to_formatted_s(:long) # FIXME: should be done via locales
    props.delete('geom')
    geojson = {
      :id => id_title,
      :type => 'Feature',
      :properties => props,
      :geometry => JSON.parse(geom.as_geojson)
    }
    geojson
  end

  def id_title
    [id, title.parameterize].join('-')
  end

  # return array of feature arrays
  def self.events_to_feature_collection(events_collection)
    events_collection.map(&:as_feature_hash)
  end

end
