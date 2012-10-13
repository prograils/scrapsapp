require 'spec_helper'

describe Observer do
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should belong_to(:membership) }
end
