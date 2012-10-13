require 'spec_helper'

describe Organization do
  it { should belong_to(:user) }
  it { should have_many(:users) }
  it { should have_many(:memberships) }
  it { should have_many(:scraps) }
  it { should validate_presence_of(:name) }
  context "uniqueness" do
    before(:each){ FactoryGirl.create(:organization) }
    it { should validate_uniqueness_of(:name) }
  end
end
