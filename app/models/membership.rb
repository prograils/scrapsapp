class Membership < ActiveRecord::Base
  MEMBERSHIP_TYPES = %w( user admin )
  
  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization

  ## VALIDATIONS
  validates :membership_type,
            :presence=>true,
            :inclusion=>{:in=>Membership::MEMBERSHIP_TYPES}


  ## ACCESSIBLE
  attr_accessible :membership_type, :user_id
end
