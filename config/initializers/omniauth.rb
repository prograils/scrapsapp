OmniAuth.config.logger = Rails.logger
github = {}
facebook = {}
twitter = {}
if Rails.env.production?
  github[:client], github[:secret] = 'd4419982c78187f5542c', 'bdfed396f58c723101977e82f68ad769b7301df0'
  twitter[:client], twitter[:secret] = '4i0EtvtZhWs7jPzJ6Pm2lQ', 'qC8y4KstEapQRwlcZ3pMVSh7ZwwrX8FWTHXM4RZQoc'
  facebook[:client], facebook[:secret] = '484808921551659', '39d54b65fac08e022d9cbad0469917f2'
elsif Rails.env.development?
  github[:client], github[:secret] = '7e0c1dbf7600cca0550e', '8d2d0b5e36d7bccb3391b2f45ccda9c02396a9d8'
  twitter[:client], twitter[:secret] = 'VULweUKPNDDRNgeCp9BQQ', 'k9ZIMXkFaM5yBmWrWwV7myV1JGxvxLCgKWIEGhrD9M'
  facebook[:client], facebook[:secret] = '473606132684588', '9b2720c83dfe772944c86990a6dd067a'
end
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, github[:client], github[:secret]
  provider :twitter, twitter[:client], twitter[:secret]
  provider :facebook, facebook[:client], facebook[:secret],
    :scope => 'email,user_website'
end
