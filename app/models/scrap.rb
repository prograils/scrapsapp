class Scrap < ActiveRecord::Base

  ## SCOPES
  scope :public, where("#{Scrap.quoted_table_name}.is_public=?", true)

  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization
  has_many :single_files, :dependent=>:destroy
  has_many :stars, :dependent=>:destroy
  has_many :starring_users, :through=>:stars, :source=>:user, :class_name=>"User"
  has_many :timeline_events, :as=>:subject, :dependent=>:destroy

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

  ## TIMELINE FU
  fires :scrap_created,  :on => :create,
                           :actor => Proc.new{|t| t.user.private_organization },
                           :secondary_subject => lambda{|t| t.organization },
                           :extra_scope => lambda{|t| t.organization }

  def to_s
    self.title
  end
end
