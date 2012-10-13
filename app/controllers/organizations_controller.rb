class OrganizationsController < ApplicationController
  before_filter :authenticate_user!, :except=>[:show]
  inherit_resources

  def index
    @organizations = current_user.organizations.all
  end


  private
    def beginning_of_association_chain
      current_user
    end
end
