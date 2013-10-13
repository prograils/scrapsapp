class Star < ActiveRecord::Base

  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :scrap
  has_many :timeline_events, :as=>:extra_scope, :dependent=>:destroy

  ## TIMELINE_FU
  fires :starred,  :on => :create,
                           :actor => Proc.new{|t| t.user.private_organization },
                           :subject =>Proc.new{|t| t.scrap },
                           :secondary_subject => lambda{|t| t.scrap.organization },
                           :extra_scope=>Proc.new{|t| t }

end
