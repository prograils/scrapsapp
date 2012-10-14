class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    
  end

  def starred
  end

  def observed
    observed_ids = current_user.observed_organizations.all.map(&:id) || []
    my_organizations = current_user.organizations.all.map(&:id) || []
    user_ids = current_user.observed_users.all.map(&:id) || []
    @q = Scrap.where('(is_public=? and (organization_id in (?) or user_id in (?))) or (organization_id in (?))', true, observed_ids, user_ids, my_organizations).search(params[:q])
    @scraps = @q.result(:distinct=>true).page(params[:page])
  end

  def my
    @q = current_user.scraps.search(params[:q])
    @scraps = @q.result(:distinct=>true).page(params[:page])
  end

  def delete_oauth
    current_user.oauth_credentials.where(:provider=>params[:id]).first.destroy
    redirect_to :back
  end
end
