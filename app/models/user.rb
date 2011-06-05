class User < ActiveRecord::Base
  devise :database_authenticatable,
       # :registerable,
       # :confirmable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  ROLES = %w(admin publisher public_relations)

  has_one :settings
  has_many :projects
  has_many :events
  has_many :articles, :foreign_key => :author_id

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :role

  before_create :set_role
  before_create :build_settings

  def events_since_login
    Event.where("created_at > ?", last_sign_in_at).all
  end

  ROLES.each do |role|
    define_method "#{role}?" do
      self.role == role
    end
  end

  private

  def set_role
    self.role = 'publisher' if self.role.nil?
  end

  def build_settings
    self.settings = Settings.new if self.settings.nil?
  end
end
