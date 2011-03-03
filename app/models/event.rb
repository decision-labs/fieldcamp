class Event < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  def as_feature_hash
    props = attributes
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
end
