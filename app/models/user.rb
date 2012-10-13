class User < ActiveRecord::Base

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
  
end
