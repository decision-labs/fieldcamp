require 'spec_helper'

describe Image do

  before :each do
    @file ||= File.open(File.join(Rails.root,"spec","fixtures","rails.png"))
  end

  it "should store the file" do
    image = Image.create!(:asset => @file, :title => "this is a test")
    image.asset.filename.should == "rails.png"
  end

  it "should require a title" do
    lambda {Image.create!(:title => "", :asset => @file)}.should raise_error(ActiveRecord::RecordInvalid)
  end
end
