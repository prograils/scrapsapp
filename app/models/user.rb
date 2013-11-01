class User < ActiveRecord::Base
  attr_accessor :bypass_validation_on_oauth
  FORBIDDEN_NAMES = %w( www mail admin public edit destroy new create update starred )

  ## SCOPES
  scope :ordered, ->{ order('username ASC') }

  ## ASSOCIATIONS
  has_one :private_organization, :class_name=>"Organization", :dependent=>:destroy
  has_many :memberships, :dependent=>:destroy
  has_many :organizations, :through=>:memberships, :source=>:organization
  has_many :managed_organizations, ->{ where('membership_type=?', 'admin') },
    :through=>:memberships, :source=>:organization, :class_name=>"Organization"

  has_many :scraps, :dependent=>:destroy
  has_many :observers, :dependent=>:destroy
  has_many :observed_organizations, :through=>:observers, :source=>:organization, :class_name=>"Organization"
  has_many :observed_users, :through=>:observers, :source=>:observed, :class_name=>"User"
  has_many :oauth_credentials, :dependent=>:destroy
  has_many :stars, :dependent=>:destroy
  has_many :starred_scraps, :through=>:stars, :source=>:scrap, :class_name=>"Scrap"

  ## DEVISE
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  ## VALIDATIONS
  validates :username,
            :uniqueness=>{:case_sensitive=>false},
            :format=>{:with=>/\A[a-z\d_\-\.\@]+\Z/i},
            :presence=>true,
            :if=>proc{|u| not u.bypass_validation_on_oauth }
  validate  :check_username_uniqueness_with_error

  ## CARRIERWAVE
  mount_uploader :photo, PhotoUploader

  ## ACCESSIBLE
  #attr_accessible :email, :password, :password_confirmation, :remember_me,
                  #:username, :first_name, :last_name

  ## BEFORE & AFTER
  after_create :create_private_organization
  after_update :change_organization_name


  def member_of?(org)
    self.memberships.where(:organization_id=>org.id).exists?
  end

  def self.from_omniauth(provider, auth, create_candidate=true)
    credentials = OauthCredential.where(:uid=>auth["uid"]).where(:provider=>provider).first
    user = nil
    if not credentials
      if auth['info']['email'].present?
        user = User.find_by_email(auth['info']['email'])
        user.fill_from_omniauth(provider, auth) if user
      end
      user = create_from_omniauth(provider, auth) if create_candidate and not user
    else
      user = credentials.user
    end
    user
  end

  def self.create_from_omniauth(provider, auth)
    #token = auth["credentials"]["token"]
    #secret = auth["credentials"]["secret"]
    #d = Date.today
    create! do |user|
      user.bypass_validation_on_oauth = true
      user.oauth_one_time_token = Devise.friendly_token[0,20]
      case provider
        when "github" then
          user.email = auth["info"]["email"]
          user.username = auth["info"]["nickname"]
          user = fill_from_github(auth,  user)
        when "twitter" then
          user.username = auth["info"]["nickname"] || user.email
          user = fill_from_twitter(auth, user)
        when "facebook" then
          user.email = auth["info"]["email"]
          user.username = auth["info"]["nickname"] || user.email
          user = fill_from_facebook(auth, user)
      end
      if user.check_username_uniqueness(true)
        check = true
        i = 1
        while check do
          user.username = "#{user.username}_#{i}"
          check = user.check_username_uniqueness
        end
      end
      if user.email.blank?
        user.email = "#{user.username}@fake.scrapsapp.com"
      end
      password = Devise.friendly_token[0,20]
      user.password = password
      user.password_confirmation = password
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.confirmed_at = Time.now
    end
  end

  def clear_oauth_one_time_token
    self.oauth_one_time_token = nil
    self.save
  end

  def fill_from_omniauth(provider, auth)
    #token = auth["credentials"]["token"]
    #secret = auth["credentials"]["secret"]
    case provider
      when "github" then
        User.fill_from_github(auth, self, true)
      when "twitter" then
        User.fill_from_twitter(auth, self, true)
      when "facebook" then
        User.fill_from_facebook(auth, self, true)
    end
  end

  def self.fill_from_twitter(auth, user, do_save=false)
    user.bypass_validation_on_oauth = true
    oac = user.oauth_credentials.where(:provider=>"twitter").first_or_initialize
    oac.uid = auth['uid']
    oac.params = {:token=>auth['credentials']['token']}
    user.oauth_credentials << oac
    user.remote_photo_url = auth['info']['image'] unless auth['info']['image'].blank?
    begin
      if auth['extra']
        user.twitter_profile = "http://twitter.com/#{auth['extra']['raw_info']['screen_name']}"
      end
    rescue
    end
    user.save if do_save
    user
  end

  def self.fill_from_facebook(auth, user, do_save=false)
    user.bypass_validation_on_oauth = true
    oac = user.oauth_credentials.where(:provider=>"facebook").first_or_initialize
    oac.uid = auth['uid']
    oac.params = {:token=>auth['credentials']['token']}
    user.oauth_credentials << oac
    begin
      user.remote_photo_url = auth['info']['image'] unless auth['info']['image'].blank?
      if auth['extra']
        user.facebook_profile = auth['extra']['raw_info'].present? ? auth['extra']['raw_info']['link'] : auth['extra']['link']
      end
    rescue
    end
    user.email = auth['info']['email'] if user.email =~ /fake\.scrapsapp\.com\Z/
    user.save if do_save
    user
  end

  def self.fill_from_github(auth, user, do_save=false)
    user.bypass_validation_on_oauth = true
    oac = user.oauth_credentials.where(:provider=>"github").first_or_initialize
    oac.uid = auth['uid']
    oac.params = {:token=>auth['credentials']['token']}
    user.oauth_credentials << oac
    begin
      user.remote_photo_url = auth['info']['image'] unless auth['info']['image'].blank?
      #user.remote_photo_url = profile["picture_url"] unless profile["picture_url"].blank?
      user.github_profile = auth['extra']['raw_info']['html_url']
    rescue
    end
    user.email = auth['info']['email'] if user.email =~ /fake\.scrapsapp\.com\Z/
    user.save! if do_save
    user
  end

    def check_username_uniqueness(check_user=false)
      ex = Organization
      ex = self.persisted? ? ex.where('user_id!=? or user_id is null', self.id) : ex.not_users
      ex = ex.where('name ilike ?', self.username)
      if check_user
        check_user = User.where('username ilike ?', self.username).exists?
      end
      User::FORBIDDEN_NAMES.member?((self.username||"").downcase.strip) || check_user || ex.exists?
    end

  private
    def create_private_organization
      o = Organization.new
      o.creating_user = true
      o.name = self.username
      o.user = self
      o.save!
      o.make_admin(self)
    end

    def change_organization_name
      if username_changed?
        po = self.private_organization
        po.creating_user = true
        po.name = self.username
        po.save
      end
    end

    def check_username_uniqueness_with_error
      ex = check_username_uniqueness
      errors.add(:username, 'is taken') if ex
    end

end
