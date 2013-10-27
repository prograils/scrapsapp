class FoldersController < ApplicationController
  before_filter :authenticate_user!, :except=>[:show]
  before_filter :require_organization_member, :except=>[:show]
  inherit_resources
  belongs_to :organization


  def index
    @folders = @organization.folders.ordered.to_a
  end

  def create
    create! { organization_folders_path(@organization) }
  end

  def update
    update! { organization_folders_path(@organization) }
  end

  private

    def require_organization_member
      @organization = current_user.organizations.find(params[:organization_id])
    end

    def build_resource_params
      unless params[resource_instance_name].presence
        [{}]
      else
        [params.require(:folder).permit(:name)]
      end
    end

end
