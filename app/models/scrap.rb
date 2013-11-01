class Scrap < ActiveRecord::Base

  ## SCOPES
  scope :public_scraps, ->{ where(is_public: true) }
  scope :ordered, ->{ order("#{Scrap.quoted_table_name}.updated_at DESC") }

  ## ASSOCIATIONS
  belongs_to :user
  belongs_to :organization
  belongs_to :folder
  has_many :single_files, dependent: :destroy
  has_many :stars, dependent: :destroy
  has_many :starring_users, through: :stars, source: :user, class_name: "User"
  has_many :timeline_events, as: :subject, dependent: :destroy

  ## VALIDATIONS
  validates :title, :user, :organization,
            presence: true

  ## FRIENDLY_ID
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

  ## ANAF
  accepts_nested_attributes_for :single_files

  ## TIMELINE FU
  fires :scrap_created, on: :create,
                         actor: Proc.new{|t| t.user.private_organization },
                         secondary_subject: lambda{|t| t.organization },
                         extra_scope: lambda{|t| t.organization }

  def to_s
    self.title
  end
end
