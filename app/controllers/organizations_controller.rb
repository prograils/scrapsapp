class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:show]
  before_filter :find_managed_organization, :except=>[:index, :show, :new, :create]
  inherit_resources

  def index
    @organizations = current_user.organizations.public.all
    index!
  end

  def show
    @organization = Organization.public.find(params[:id])
    show!
  end

  def create
    @organization = Organization.new
    @membership = current_user.membership.build do |m|
      m.membership_type = 'admin'
    end
    @organization.memberships << @membership
    create!
  end


  private
    def beginning_of_association_chain
      current_user
    end

    def find_managed_organization
      @organization = current_user.managed_organizations.public.find(params[:id])
    end
end
