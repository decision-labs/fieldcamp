class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    case user.role
    when 'admin'
      can :manage, :all
    when 'publisher'
      can :read, :all
      can :destroy, Event, :user_id => user.id
      can :update,  Event, :user_id => user.id
      can :create,  Event
    when 'public_relations'
      can :manage, Article, :author_id => user.id
    else
      can :read, :all
    end

  end
end
