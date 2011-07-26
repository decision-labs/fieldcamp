class Distribution < ActiveRecord::Base
  belongs_to :event
  validates :item, :presence => true
  validates :quantity_of_items, :presence => true
  validates :quantity_of_items, :numericality => true
  validates :number_of_recipients, :numericality => true
  validates :event_id, :numericality => true

  def description
    str = [self.quantity_of_items, self.unit, self.item].join(" ")
    unless self.recipient.blank?
      str = "#{str} #{I18n.t('provided_to')}"
      str = "#{str} #{self.number_of_recipients}" unless self.number_of_recipients.blank?
      str = "#{str} #{self.recipient}"
      str
    end
  end

end
