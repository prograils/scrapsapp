class OauthCredential < ActiveRecord::Base
  serialize :params

  ## ASSOCIATIONS
  belongs_to :user

  ## VALIDATIONS
  validates :provider, :uid, :user,
            presence: true

  def to_s
    "#{self.provider} - #{self.uid}"
  end
end
