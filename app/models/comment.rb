class Comment < ActiveRecord::Base
  ## SCOPES
  scope :ordered, ->{ order(:created_at) }

  ## ASSOCIATIONS
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  ## VALIDATIONS
  validates :comment_body, :user, :commentable,
            presence: true

  def to_s
    self.comment_body
  end
end
