class TimelineEvent < ActiveRecord::Base
  belongs_to :account
  belongs_to :actor,              :polymorphic => true
  belongs_to :subject,            :polymorphic => true
  belongs_to :secondary_subject,  :polymorphic => true
  belongs_to :extra_scope,              :polymorphic => true

  attr_accessible :actor, :subject, :secondary_subject, :extra_scope, :event_type
end
