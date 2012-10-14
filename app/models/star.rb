class Star < ActiveRecord::Base

  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :scrap
  
  ## ACCESSIBLE
  attr_accessible
end
