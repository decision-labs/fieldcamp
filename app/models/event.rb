class Event < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_one :location, :through => :project
  has_many :images, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :distributions, :dependent => :destroy
  has_and_belongs_to_many :partners
  has_and_belongs_to_many :sectors

  # Rgeo
  set_rgeo_factory_for_column(:geom, RGeo::Geographic.simple_mercator_factory(:has_z_coordinate => true))
  RGeo::ActiveRecord::GeometryMixin.set_json_generator(:geojson)
  GEOM_FACTORY ||= RGeo::Geographic.simple_mercator_factory

  accepts_nested_attributes_for :images, :allow_destroy => true,  :reject_if => :all_blank
  accepts_nested_attributes_for :documents, :allow_destroy => true,  :reject_if => :all_blank
  accepts_nested_attributes_for :distributions, :allow_destroy => true, :reject_if => :all_blank

  validates_presence_of :title, :message => "Title can't be blank."
  validates_with EventAddressValidator

  scope :desc, order("events.updated_at DESC")

  attr_accessible :title, :description, :address, :project_id, :partner_ids, :sector_ids, :images_attributes, :distributions_attributes, :documents_attributes, :geom

  def as_feature_hash
    props = attributes
    props["description"] = RDiscount.new(attributes["description"]).to_html if !attributes["description"].nil?
    props["updated_at"] = attributes["updated_at"].to_formatted_s(:long) # FIXME: should be done via locales
    props.delete('geom')
    props['distributions'] = distributions.collect(&:description)

    geojson = {
      :id => id_title,
      :type => 'Feature',
      :properties => props,
      :geometry => geom.as_json
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
