require 'spec_helper'

describe CommentsController do
  before do
    login_user
    @user = User.first
    @organization = FactoryGirl.create(:organization)
    @scrap = FactoryGirl.create(:scrap, user: @user, organization: @organization)
  end

  describe "POST 'create'" do
    it "returns http success" do
      post 'create', {organization_id: @organization.id, scrap_id: @scrap.id,
                        comment: {comment_body: "terefere"}, format: :js }
      response.should be_success
    end
  end

end
