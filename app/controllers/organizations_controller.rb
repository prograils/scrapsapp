class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:show, :public]
  before_filter :find_managed_organization, :except=>[:index, :show, :new, :create, :public, :observe, :stop_observing]
  inherit_resources

  ## inherited overwrites
  def index
    @q = current_user.organizations.public.search(params[:q])
    @organizations = @q.result(:distinct=>true).page(params[:page])
    @can_manage = true
    index!
  end

  def show
    @organization = Organization.find(params[:id])
    show!
  end
  
  def create
    @organization = Organization.new params[:organization]
    @membership = current_user.memberships.build do |m|
      m.membership_type = 'admin'
    end
    @organization.memberships << @membership
    create!
  end
  
  def update
    update! do |s,f|
      f.html do
        unless @organization.permissions
          return render(:action=>"edit")
        else
          return render(:action=>"members")
        end
      end
    end
  end
  ## END inherited overwrites

  def members
  end

  def public
    @q = Organization.public.search(params[:q])
    @organizations = @q.result(:distinct=>true).page(params[:page])
    @can_manage = false
  end

  def observe
    @organization = Organization.find(params[:id])
    Observer.observe_organization(current_user, @organization)
    redirect_to :back
  end

  def stop_observing
    @organization = Organization.public.find(params[:id])
    current_user.observers.where(:organization_id=>@organization.id).destroy_all
    redirect_to :back
  end


  private
    def begin_of_association_chain
      current_user
    end

    def find_managed_organization
      @organization = current_user.managed_organizations.public.find(params[:id])
    end
end
