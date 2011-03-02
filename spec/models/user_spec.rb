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
end
