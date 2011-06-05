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
    end # it
  end # describe #events_since_login

  describe "articles" do
    before :each do
      @article = Article.make
      @author  = @article.author
    end

    describe "admins" do
      it "should be able to manage articles" do
        ability = Ability.new(User.make(:role => "admin"))
        ability.can?(:manage, @article).should == true
      end
    end

    describe "author" do
      it "should be able to manage their own articles" do
        ability = Ability.new(@author)
        ability.can?(:manage, @article).should == true
      end

      it "should respond_to? :articles" do
        @author.articles.should include(@article)
      end

      describe "who is not this article's author" do
        before :each do
          @another_author = Article.make.author
          @ability = Ability.new(@another_author)
        end

        it "should not be able to destroy other's articles" do
          @ability.cannot?(:destroy, @article).should == true
        end

        it "should not be able to edit other's articles" do
          @ability.cannot?(:edit, @article).should == true
        end
      end
    end # describe author
  end

  describe "responds to role" do
    describe "admin" do
      before :each do
        @user = User.make(:role => "admin")
      end
      it "should be admin" do
        @user.should be_admin
      end

      it "should not be_publisher" do
        @user.should_not be_publisher
      end

      it "should not be public_relations" do
        @user.should_not be_public_relations
      end
    end

    describe "publisher" do
      before :each do
        @user = User.make(:role => "publisher")
      end
      it "should not be admin" do
        @user.should_not be_admin
      end

      it "should be_publisher" do
        @user.should be_publisher
      end

      it "should not be public_relations" do
        @user.should_not be_public_relations
      end
    end

    describe "public_relations" do
      before :each do
        @user = User.make(:role => "public_relations")
      end
      it "should not be admin" do
        @user.should_not be_admin
      end

      it "should not be_publisher" do
        @user.should_not be_publisher
      end

      it "should be public_relations" do
        @user.should be_public_relations
      end
    end
  end # responds to role
end
