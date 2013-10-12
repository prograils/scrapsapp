class Organization < ActiveRecord::Base
  attr_accessor :permissions, :creating_user

  ## SCOPES
  scope :public, where("#{Organization.quoted_table_name}.user_id is null")


  ## ASSOCIATIONS
  belongs_to :user
  has_many :memberships, :dependent=>:destroy
  has_many :users, :through=>:memberships, :source=>:user
  has_many :admins, :through=>:memberships, :source=>:user, :class_name=>"User",
            :conditions=>['memberships.membership_type=?', 'admin']
  has_many :scraps, :dependent=>:destroy
  has_many :observers, :dependent=>:destroy
  has_many :observing_users, :through=>:observers, :source=>:user, :class_name=>"User"
  has_many :timeline_events, :as=>:secondary_subject, :dependent=>:destroy
  has_many :actored_timeline_events, :as=>:actor, :dependent=>:destroy, class_name: "TimelineEvent"
  has_many :folders, :dependent=>:destroy


  ## VALIDATIONS
  validates :name,
            :uniqueness=>{:case_sensitive=>false},
            :presence=>true
  validate  :check_name_uniqueness

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

  private
    def check_name_uniqueness
      ex = User.where('username ilike ?', self.name).exists? && (not @creating_user)
      errors.add(:name, 'is taken') if ex or User::FORBIDDEN_NAMES.member?((self.name||"").downcase.strip)
    end
end
