require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe User do
  it "can destroy any project if their role is admin" do
    user = User.make(:role => 'admin')
    ability = Ability.new(user)

    assert ability.can?(:destroy, Project.new(:user => user))
    assert ability.can?(:destroy, Project.new(:user => User.make(:role => 'admin')))
  end

  it "cannot destroy any project if their role is not admin" do
    user = User.make
    ability = Ability.new(user)

    assert ability.cannot?(:destroy, Project.new(:user => user))
    assert ability.cannot?(:destroy, Project.new(:user => User.make(:role => 'admin')))
  end

  require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

  describe '#events_since_login', :wip => true do
    it "event feed since last log in" do
      project = Project.make
      project.save
      user = project.user
      events_since_login = []
      4.times do
        event = Event.make(:project => nil)

        p = Point.from_x_y_z(rand(70), rand(50), rand(10), 4326)
        event.geom = p

        project.events << event
        events_since_login << event
      end

      user.update_attribute('last_sign_in_at', 5.hours.ago)
      user.events_since_login.size == 4

      user.events_since_login == events_since_login

      user.update_attribute('last_sign_in_at', Time.now)
      user.events_since_login.size == 0
    end

    it '#recent_events' do
      
    end
  end
end
