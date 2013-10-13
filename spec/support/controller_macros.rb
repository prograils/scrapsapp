module ControllerMacros
  def login_admin(user=nil, &block)
    current_admin = user || FactoryGirl.create(:admin)
    if defined?(request) && request.present?
      sign_in(current_admin)
    else
      login_as(current_admin, :scope => :admin)
    end
    block.call if block.present?
    return self
  end

  def login_user(user=nil, &block)
    current_user = user || FactoryGirl.create(:user)
    if defined?(request) && request.present?
      sign_in(current_user)
    else
      login_as(current_user, :scope => :user)
    end
    block.call if block.present?
    return self
  end

end
