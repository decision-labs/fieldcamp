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
    end
  end
end
