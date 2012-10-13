class Organization < ActiveRecord::Base
  attr_accessor :permissions

  ## SCOPES
  scope :public, where("#{Organization.quoted_table_name}.user_id is null")


  ## ASSOCIATIONS
  belongs_to :user
  has_many :memberships, :dependent=>:destroy
  has_many :users, :through=>:memberships, :source=>:user
  has_many :admins, :through=>:memberships, :source=>:user, :class_name=>"User",
            :conditions=>['memberships.membership_type=?', 'admin']

  ## VALIDATIONS
  validates :name,
            :uniqueness=>true,
            :presence=>true
  
  ## FRIENDLY_ID
  extend FriendlyId
  friendly_id :name, use: :slugged

  ## ANAF
  accepts_nested_attributes_for :memberships, :reject_if=>proc{|m| m['user_id'].blank? or m['membership_type'].blank? }, :allow_destroy=>true


  ## ACCESSIBLE
  attr_accessible :name, :memberships_attributes, :permissions

  def to_s
    self.name
  end

  def make_admin(u)
    membership = self.memberships.where(:user_id=>u.id).first_or_initialize 
    membership.membership_type = 'admin'
    membership.save!
  end

  def make_user(u)
    membership = self.memberships.where(:user_id=>u.id).first_or_initialize 
    membership.membership_type = 'user'
    membership.save!
  end
end
