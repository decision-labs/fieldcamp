require 'spec_helper'

describe Article do

  before :each do
    @article = Article.make
  end

  # fixture tests
  it "should not be published by default" do
    @article.should_not be_published
  end

  it "should belong to an author by default" do
    @article.author.should_not be_nil
  end

  it "should belong to a project default" do
    @article.project.should_not be_nil
  end

  # publishing
  it "should be publishable" do
    @article.publish
    @article.should be_published
  end

  it "should be publishable for a future date but remain umpublished" do
    @article.publish(7.days.from_now)
    @article.should_not be_published
  end

  # validations
  it "should require an author" do
    lambda {Article.make(:author => nil)}.should raise_error ActiveRecord::RecordInvalid
  end

  it "should not store content as plain markdown" do
    @article.content.should match(/# This is an Article/)
  end

  it "should have a content_processed method" do
    @article.content_html.should match(/<h1>This is an Article<\/h1>/)
  end
end
