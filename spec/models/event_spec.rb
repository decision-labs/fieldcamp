require 'spec_helper'

describe Event do
  it { should have_and_belong_to_many(:sectors) }
  it { should have_and_belong_to_many(:partners) }
  it { should have_many(:distributions), :dependent => :destroy }
  # it { should accept_nested_attributes_for(:distributions, :allow_destroy => true)}
end
