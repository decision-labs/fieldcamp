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

  attr_accessible :email,
                  :password,
                  :password_confirmation,
                  :remember_me,
                  :role

  before_create :set_role

  private

  def set_role
    self.role = 'publisher' if self.role.nil?
  end
end
