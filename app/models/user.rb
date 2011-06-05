class User < ActiveRecord::Base
  devise :database_authenticatable,
       # :registerable,
       # :confirmable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  ROLES = %w(admin publisher)

  has_one :settings
  has_many :projects
  has_many :events

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

  private

  def set_role
    self.role = 'publisher' if self.role.nil?
  end

  def build_settings
    self.settings = Settings.new if self.settings.nil?
  end
end
