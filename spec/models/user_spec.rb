require 'spec_helper'

describe User do
  it { should validate_presence_of(:username) }
  it { should have_one(:private_organization) }
  it { should have_many(:memberships) }
  it { should have_many(:organizations) }
  it { should have_many(:managed_organizations) }
  it { should have_many(:scraps) }
  it { should have_many(:observed_organizations) }

  context :uniquness do
    before(:each) do
      @user = FactoryGirl.create(:user)
    end
    it { should validate_uniqueness_of(:username) }
  end

  context "private organization" do
    it "should be created when user is created" do
      Organization.count.should == 0
      User.count.should == 0
      @user = FactoryGirl.create(:user)
      @user.should_not be_new_record
      @user.private_organization.should_not be_nil
      Organization.count.should == 1
      User.count.should == 1
      @user.private_organization.name.should == @user.username
    end

    it "should change organization name when username is changed" do
      @user = FactoryGirl.create(:user, :username=>"mlitwiniuk")
      @user.private_organization.name.should == "mlitwiniuk"
      @user.update_attributes({:username=>"tas"})
      @user.reload
      @user.username.should == "tas"
      @user.private_organization.name.should == "tas"
    end
  end
end
