class Membership < ActiveRecord::Base
  MEMBERSHIP_TYPES = %w( user admin )
  
  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization, :counter_cache=>true

  ## VALIDATIONS
  validates :membership_type,
            :presence=>true,
            :inclusion=>{:in=>Membership::MEMBERSHIP_TYPES}
  validates :user_id,
            :uniqueness=>{:scope=>:organization_id}


  ## ACCESSIBLE
  attr_accessible :membership_type, :user_id
end
