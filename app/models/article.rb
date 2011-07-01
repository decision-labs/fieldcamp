class Article < ActiveRecord::Base

  attr_accessible :title, :content, :published_at, :draft

  belongs_to :author, :class_name => "User"
  belongs_to :project

  validates :author_id, :presence => true
  validates :project_id, :presence => true

  def published?
    published_at && published_at < Time.now
  end

  def publish(date=nil)
    date ||= Time.now
    update_attribute :published_at, date
  end

  def draft
    !published?
  end

  alias_method :draft?, :draft

  def content_html
    RDiscount.new(self.content).to_html.html_safe
  end

  def unpublish!
    update_attribute :published_at, nil
  end
end
