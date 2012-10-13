module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      admin = FactoryGirl.create(:user) # Using factory girl as an example
      admin.confirm!
      admin.is_admin = true
      admin.save
      sign_in admin
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      @user.confirm! 
      sign_in @user
    end
  end
end
