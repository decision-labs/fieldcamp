class Distribution < ActiveRecord::Base
  belongs_to :event
  validates :item, :presence => true
  validates :quantity_of_items, :presence => true
  validates :quantity_of_items, :numericality => true
  validates :number_of_recepiants, :numericality => true
  validates :event_id, :numericality => true
end
