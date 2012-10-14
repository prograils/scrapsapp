class HomeController < ApplicationController
  before_filter :skip_left_column

  def index
  end
end
