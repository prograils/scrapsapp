class Scrap < ActiveRecord::Base

  ## SCOPES
  scope :public, where("#{Scrap.quoted_table_name}.is_public=?", true)

  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization
  has_many :single_files, :dependent=>:destroy

  ## VALIDATIONS
  validates :title, 
            :presence=>true

  ## FRIENDLY_ID
  extend FriendlyId
  friendly_id :title, use: :slugged

  ## ANAF
  accepts_nested_attributes_for :single_files
  
  ## ACCESSIBLE
  attr_accessible :description, :is_public, :title, :single_files_attributes

  def to_s
    self.title
  end
end
