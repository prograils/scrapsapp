class DashboardController < ApplicationController
  before_filter :authenticate_user!

  def index
    #@timeline_events = TimelineEvent.joins("LEFT JOIN #{s} on #{te}.actor_id=#{s}.user_id").where("(#{s}.subscriber_id=? AND ((#{s}.group_id=#{te}.extra_scope_id AND #{te}.extra_scope_type=?) OR #{s}.is_general=?)) OR #{te}.actor_id=?", u.id, Group.name, true, u.id).order("#{te}.created_at DESC").page(params[:page])
    s = Scrap.quoted_table_name
    o = Organization.quoted_table_name
    te = TimelineEvent.quoted_table_name
    org_ids = current_user.organizations.all.map(&:id) || []
    #org_ids.delete(current_user.private_organization.id)
    observed_ids = current_user.observed_organizations.all.map(&:id) || []
    logger.info "te #{observed_ids.member?(current_user.private_organization.id)}"
    #observed_ids.delete(current_user.private_organization.id)
    logger.info "te #{observed_ids.member?(current_user.private_organization.id)}"
    @timeline_events = TimelineEvent.joins("LEFT JOIN #{s} on #{te}.subject_id=#{s}.id").where("(subject_id is null and actor_id in (?)) OR (subject_id is not null and (#{s}.is_public=? or #{s}.organization_id in (?)))", observed_ids, true, org_ids).where('secondary_subject_id in (?)', observed_ids).where('actor_id != ?', current_user.private_organization.id).where("#{te}.created_at>?", current_user.confirmed_at).order("#{te}.created_at DESC").page(params[:page])
    #@timeline_events = TimelineEvent.all
  end

  def starred
    my_organizations = current_user.organizations.all.map(&:id) || []
    #starred_ids = current_user.stars.all.map(&:scrap_id) || []
    @q = current_user.starred_scraps.where('is_public=? or organization_id in (?)', true, my_organizations).search(params[:q])
    @scraps = @q.result(:distinct=>true).page(params[:page])
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
