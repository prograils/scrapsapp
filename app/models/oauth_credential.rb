class OauthCredential < ActiveRecord::Base
  serialize :params

  ## ASSOCIATIONS
  belongs_to :user

  ## ACCESSIBLE
  attr_accessible

  def to_s
    "#{self.provider} - #{self.uid}"
  end
end
