class User < ActiveRecord::Base

  ## SCOPES

  ## ASSOCIATIONS
  has_one :private_organization, :class_name=>"Organization"

  ## DEVISE
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## VALIDATIONS
  validates :username,
            :presence=>true,
            :uniqueness=>true

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
  
end
