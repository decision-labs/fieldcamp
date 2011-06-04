require 'spec_helper'

describe Image do
  it "should store the file" do
    file = File.open(File.join(Rails.root,"spec","fixtures","rails.png"))
    image = Image.create!(:file => file, :title => "this is a test")
    image.file.filename.should == "rails.png"
  end

  it "should require a title" do
    lambda {Image.create!(:title => "")}.should raise_error(ActiveRecord::RecordInvalid)
  end
end
