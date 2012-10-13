class User < ActiveRecord::Base
  FORBIDDEN_NAMES = %w( www mail admin public edit destroy new create update )

  ## SCOPES
  scope :ordered, order('username ASC')

  ## ASSOCIATIONS
  has_one :private_organization, :class_name=>"Organization"
  has_many :memberships, :dependent=>:destroy
  has_many :organizations, :through=>:memberships, :source=>:organization
  has_many :managed_organizations, :through=>:memberships, :source=>:organization, 
            :class_name=>"Organization", :conditions=>['membership_type=?', 'admin']

  ## DEVISE
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## VALIDATIONS
  validates :username,
            :uniqueness=>{:case_sensitive=>false},
            :format=>{:with=>/\A[a-z\d_]+\Z/i},
            :presence=>true
  validate  :check_username_uniqueness

  ## ACCESSIBLE
  attr_accessible :email, :password, :password_confirmation, :remember_me, 
                  :username, :first_name, :last_name

  ## BEFORE & AFTER
  after_create :create_private_organization
  after_update :change_organization_name


  private
    def create_private_organization
      o = Organization.new
      o.name = self.username
      o.user = self
      o.save!
    end

    def change_organization_name
      if username_changed?
        po = self.private_organization
        po.name = self.username
        po.save
      end
    end
    
    def check_username_uniqueness
      ex = Organization
      ex = self.persisted? ? ex.where('user_id!=? or user_id is null', self.id) : ex.public
      ex = ex.where('name ilike ?', self.username).exists?
      errors.add(:username, 'is taken') if ex or User::FORBIDDEN_NAMES.member?(self.username.downcase.strip)
    end
  
end
