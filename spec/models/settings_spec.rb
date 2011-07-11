require 'spec_helper'

describe Settings do
  it { should validate_presence_of(:location_id) }
  it { should validate_format_of(:location_id).not_with('').with_message(/invalid/) }
end
