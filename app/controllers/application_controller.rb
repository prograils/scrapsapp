class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout
  before_filter :get_menu_organizations

  private
    def set_layout
      if request.headers['X-PJAX']
        false
      else
        "application"
      end
    end

    def skip_left_column
      @skip_left_column = true
    end

    def get_menu_organizations
      if current_user
        @menu_organizations = current_user.organizations.ordered
      end
    end
end
