class ScrapsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:index, :show]
  before_filter :find_organization
  before_filter :find_public_scrap, :only=>[:show, :star, :unstar]
  before_filter :find_and_check_ownership, :except=>[:index, :show, :new, :create, :star, :unstar]
  before_filter :check_organization_membership, :only=>[:new, :create]


  inherit_resources
  belongs_to :organization

  ## inherited overwrites
  def index
    @q = @organization.scraps
    unless @organization.users.member?(current_user)
      @q = @q.public
    end
    @q = @q.search(params[:q])
    @scraps = @q.result(:distinct=>true).page(params[:page])
  end

  def new
    @scrap = @organization.scraps.new
    @scrap.single_files.build
    new!
  end

  def create
    @scrap = @organization.scraps.new(params[:scrap])
    @scrap.user = current_user
    create!
  end
  ## END inherited overwrites
  
  def star
    s = current_user.stars.where(:scrap_id=>@scrap.id).first_or_create!
    redirect_to :back
  end

  def unstar
    current_user.stars.where(:scrap_id=>@scrap.id).destroy_all
    redirect_to :back
  end

  private
    def find_organization
      @organization = Organization.find(params[:organization_id])
    end

    def find_and_check_ownership
      redirect_to(root_url) unless @organization.users.member?(current_user)
      @scrap = @organization.scraps.find(params[:id])
    end

    def find_public_scrap
      @scrap = if @organization.users.member?(current_user)
                  @organization.scraps.find(params[:id])
                else
                  @organization.scraps.public.find(params[:id])
                end
    end

    def check_organization_membership
      redirect_to(root_url) unless @organization.users.member?(current_user)
    end
  
end
