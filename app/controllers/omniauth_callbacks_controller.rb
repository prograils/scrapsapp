class OmniauthCallbacksController < ApplicationController
  def callback
    auth = env["omniauth.auth"]
    # if user is signed in
    if current_user
      @user = current_user
      # check if user already exists
      c = User.from_omniauth(params[:provider], auth, false)
      # if user does not exists or user is same as currently signed in, proceed
      if c.blank? or c==current_user
        ret = session[:oauth_return_to] || root_url
        session.delete(:oauth_return_to)
        @user.fill_from_omniauth(params[:provider], auth)
        flash[:notice] = t('flash_messages.candidates.account_linked', :provider=>params[:provider], :default=>"We've successfully updated your account with %{provider}")
        # if profile is already filled in
        #if @candidate.profile_complete? and ret == root_url
          redirect_to root_url
        #else # else redirect user and help him fill in his account
          #redirect_to ret
        #end
      else # else... someone is trying to overtake currently linked account. block!
        flash[:warning] = t('flash_messages.candidates.possible_account_overtake')
        redirect_to root_url
      end
    else # else...user is not signed in
      @user = User.from_omniauth(params[:provider], auth)
      request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in :user, @user, :bypass=>true
      sign_in_and_redirect @user, :event => :authentication
    end
  end
end
