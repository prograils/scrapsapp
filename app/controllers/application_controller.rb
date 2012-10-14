class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout

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
end
