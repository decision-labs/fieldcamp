require 'spec_helper'

describe Event do
  it { should have_and_belong_to_many(:sectors) }
  it { should have_and_belong_to_many(:partners) }
end
