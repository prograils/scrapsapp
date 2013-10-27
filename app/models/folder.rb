class Folder < ActiveRecord::Base

  ## SCOPES
  scope :ordered, ->{ order("#{Folder.quoted_table_name}.name ASC") }

  ## ASSOCIATIONS
  belongs_to :organization
  has_many :scraps, :dependent=>:nullify

  ## VALIDATIONS
  validates :name,
            :presence=>true

  ## FRIENDLY_ID
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  def to_s
    self.name
  end
end
