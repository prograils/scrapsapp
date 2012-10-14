require 'spec_helper'

describe Folder do
  it { should belong_to(:organization) }
  it { should have_many(:scraps) }
  it { should validate_presence_of(:name) }
end
