class Users::SessionsController < Devise::SessionsController
  before_filter :skip_left_column, :only=>[:new, :create]
end
