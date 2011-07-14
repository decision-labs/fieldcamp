require 'spec_helper'

describe Distribution do
  it { should belong_to(:event) }
  it { should validate_presence_of(:item) }
  it { should validate_presence_of(:quantity_of_items) }
  it { should validate_numericality_of(:quantity_of_items) }
  it { should validate_numericality_of(:number_of_recipients ) }
  it { should validate_numericality_of(:event_id) }
  # it { should validate_format_of(:location_id).not_with('').with_message(/invalid/) }
end
