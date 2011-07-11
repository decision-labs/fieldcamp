require 'spec_helper'

describe Project do
  it { should validate_presence_of(:end_date) }
  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:title) }
end
