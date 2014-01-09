class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_organization
  before_filter :find_public_scrap

  respond_to :js, :html

  def create
    @comment = @scrap.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    respond_with(@comment) do |format|
      format.html { redirect_to([@organization, @scrap]) }
      format.js { render }
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:comment_body)
    end

    # moved to concern in different branch, let's leave it like it is for now.
    def find_organization
      @organization = Organization.find(params[:organization_id])
    end

    def find_public_scrap
      @scrap = if @organization.users.member?(current_user)
                  @organization.scraps.find(params[:scrap_id])
                else
                  @organization.scraps.public_scraps.find(params[:scrap_id])
                end
    end
end
