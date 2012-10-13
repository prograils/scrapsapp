require 'spec_helper'

describe Membership do
  it { should belong_to(:user) }
  it { should belong_to(:organization) }
  it { should validate_presence_of(:membership_type) }
  it { should ensure_inclusion_of(:membership_type).in_array(Membership::MEMBERSHIP_TYPES) }
end
