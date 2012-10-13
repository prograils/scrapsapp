class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    
  end

  def starred
  end

  def observed
    observed_ids = current_user.observed_organizations.all.map(&:id) || []
    user_ids = current_user.observed_users.all.map(&:id) || []
    @q = Scrap.public.where('organization_id in (?) or user_id in (?)', observed_ids, user_ids).search(params[:q])
    @scraps = @q.result(:distinct=>true).page(params[:page])
  end

  def my
    @q = current_user.scraps.search(params[:q])
    @scraps = @q.result(:distinct=>true).page(params[:page])
  end
end
