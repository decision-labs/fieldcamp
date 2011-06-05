class Article < ActiveRecord::Base

  attr_accessible :title, :content, :published_at, :draft, :project_id, :published, :author_id

  belongs_to :author, :class_name => "User"
  belongs_to :project
  belongs_to :article

  validates :project_id, :presence => true
  validates :author_id, :presence => true
  validates :content, :presence => true
  validates :title, :presence => true

  scope :chronological, lambda { |ascending| ascending ? order('created_at ASC') : order('created_at DESC') }
  scope :published, where(:published => true).where("published_at < ?", Time.now)


  def published?
    published_at && published_at < Time.now
  end

  def publish(date=nil)
    date ||= Time.now
    update_attribute :published_at, date
    update_attribute :published, true
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
    update_attribute :published, false
  end
end
