require 'spec_helper'

describe Scrap do
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should validate_presence_of(:title) }
  it { should have_many(:single_files) }
  it { should have_many(:stars) }
  it { should have_many(:starring_users) }
end
