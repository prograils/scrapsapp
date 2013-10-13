class OauthCredential < ActiveRecord::Base
  serialize :params

  ## ASSOCIATIONS
  belongs_to :user

  def to_s
    "#{self.provider} - #{self.uid}"
  end
end
