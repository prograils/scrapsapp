class Membership < ActiveRecord::Base
  MEMBERSHIP_TYPES = %w( user admin )
  
  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization, :counter_cache=>true
  has_one :observer, :dependent=>:destroy

  ## VALIDATIONS
  validates :membership_type,
            :presence=>true,
            :inclusion=>{:in=>Membership::MEMBERSHIP_TYPES}
  validates :user_id,
            :uniqueness=>{:scope=>:organization_id}


  ## ACCESSIBLE
  attr_accessible :membership_type, :user_id

  ## BEFORE & AFTER
  after_create :create_observer


  private
    def create_observer
      o = self.user.observers.where(:organization_id=>self.organization_id).first
      if o
        o.membership = self
        o.save!
      else
        o = Observer.new
        o.user = self.user
        o.organization = self.organization
        o.membership = self
        o.save!
      end
    end
end
