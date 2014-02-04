OmniAuth.config.logger = Rails.logger
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['SCRAPSAPP_GITHUB_OAUTH_CLIENT'], ENV['SCRAPSAPP_GITHUB_OAUTH_SECRET']
  provider :twitter, ENV['SCRAPSAPP_TWITTER_OAUTH_CLIENT'], ENV['SCRAPSAPP_TWITTER_OAUTH_SECRET']
  provider :facebook, ENV['SCRAPSAPP_FACEBOOK_OAUTH_CLIENT'], ENV['SCRAPSAPP_FACEBOOK_OAUTH_SECRET'],
    :scope => 'email,user_website'
end
