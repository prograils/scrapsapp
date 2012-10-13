require 'spec_helper'

describe User do
  it { should validate_presence_of(:username) }

  context :uniquness do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it { should validate_uniqueness_of(:username) }
  end
end
