require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should validate_presence_of(:comment_body) }
end
