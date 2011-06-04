class Article < ActiveRecord::Base

  attr_accessible :content, :published_at

  belongs_to :author, :class_name => "User"

  validates :author_id, :presence => true

  def published?
    published_at && published_at < Time.now
  end

  def publish(date=nil)
    date ||= Time.now
    update_attribute :published_at, date
  end

  def content_html
    RDiscount.new(self.content).to_html.html_safe
  end

end
