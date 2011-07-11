require 'spec_helper'

describe Project do
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:location_id) }
  it { should validate_format_of(:location_id).not_with('').with_message(/invalid/) }
end
