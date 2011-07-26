require 'spec_helper'

describe Distribution do
  it { should belong_to(:event) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:quantity_of_items) }
  it { should validate_numericality_of(:quantity_of_items) }
  it { should validate_numericality_of(:number_of_recipients ) }
  it { should validate_numericality_of(:event_id) }
  # it { should validate_format_of(:location_id).not_with('').with_message(/invalid/) }

  describe '#description' do
    before do
      @valid_params = {
        :item                 => "water",
        :quantity_of_items    => 100,
        :unit                 => "liters",
        :recipient            => "villages",
        :number_of_recipients => 10
      }
    end
    it "should return a string" do
      distribution = Distribution.make(@valid_params)
      distribution.description.should == "#{@valid_params[:quantity_of_items]} #{@valid_params[:unit]} #{@valid_params[:item]} provided to #{@valid_params[:number_of_recipients]} #{@valid_params[:recipient]}"
    end

    it "should return a string with blank recepient" do
      distribution = Distribution.make(:item => @valid_params[:item], :quantity_of_items => @valid_params[:quantity_of_items], :unit => @valid_params[:unit])
      distribution.description.should == "#{@valid_params[:quantity_of_items]} #{@valid_params[:unit]} #{@valid_params[:item]}"
    end
  end
end
