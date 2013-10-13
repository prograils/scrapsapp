class Observer < ActiveRecord::Base

  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization
  belongs_to :membership
  belongs_to :observed, :class_name=>"User"
  has_many :timeline_events, :as=>:extra_scope, :dependent=>:destroy

  ## TIMELINE FU
  fires :started_observing,  :on => :create,
                           :actor => Proc.new{|t| t.user.private_organization },
                           :subject => Proc.new{|t| nil },
                           :secondary_subject=>Proc.new{|t| t.organization },
                           :extra_scope=>Proc.new{|t| t }


  def self.observe_organization(usr, org)
    o = Observer.new
    o.user = usr
    o.organization = org
    o.observed_id = org.user_id
    o.save!
    o
  end
end
