module RequestMacros

  # for use in request specs
  def sign_in_as_a_valid_user(user=nil)
    @user = user.blank? ? FactoryGirl.create(:user) : user
    @user.confirm!
    post_via_redirect user_session_path, 'user[email]' => @user.email, 'user[password]' => @user.password
  end
end
