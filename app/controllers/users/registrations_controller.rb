class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_scope!
  before_filter :authenticate_user!, :except=>[:new, :create, :cancel]
  #before_filter :require_candidate!, :except=>[:new, :create, :cancel]
  before_filter :set_resource, :only=>[:update, :edit]
  before_filter :skip_left_column, :only=>[:new, :create]

  def update
    @user = current_user
    successfully_updated = if @user.oauth_one_time_token.present?
                             @user.skip_reconfirmation!
                             @user.update_attributes(params[:user])
                           else
                             @user.update_with_password(params[:user])
                             #@user.update_attributes(params[:user])
                           end
    if successfully_updated
      @user.oauth_one_time_token = nil
      @user.save
      flash[:notice] = 'Account updated!'
      sign_in :user, @user, :bypass=>true , :event=>:authentication
      redirect_to root_url
    else
      @user.errors.each{|k,v| logger.info "#{k}: #{v}"}
      render :action=> :edit
    end
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << :username
      devise_parameter_sanitizer.for(:sign_up) << :first_name
      devise_parameter_sanitizer.for(:sign_up) << :last_name
    end

    def set_resource
      self.resource = current_user
    end
end
