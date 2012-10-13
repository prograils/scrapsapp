class Observer < ActiveRecord::Base

  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization
  belongs_to :membership
  belongs_to :observed, :class_name=>"User"
  
  ## ACCESSIBLE
  attr_accessible

  def self.observe_organization(usr, org)
    o = Observer.new
    o.user = usr
    o.organization = org
    o.observed_id = org.user_id
    o.save!
    o
  end
end
