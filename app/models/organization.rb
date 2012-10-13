class Organization < ActiveRecord::Base

  ## SCOPES
  scope :public, where("#{Organization.quoted_table_name}.user_id is null")


  ## ASSOCIATIONS
  belongs_to :user

  ## VALIDATIONS
  validates :name,
            :uniqueness=>true,
            :presence=>true
  
  ## FRIENDLY_ID
  extend FriendlyId
  friendly_id :name, use: :slugged


  ## ACCESSIBLE
  attr_accessible :name

  def to_s
    self.name
  end
end
