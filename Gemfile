source 'https://rubygems.org'
gem 'rails', '3.2.8'
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem "pg", ">= 0.14.1"
gem "haml", ">= 3.1.7"
gem "bootstrap-sass", ">= 2.1.0.0"
gem "devise", ">= 2.1.2"
gem "simple_form", ">= 2.0.3"
gem "friendly_id", "~> 4.0.1"

group :development do
  gem "haml-rails", ">= 0.3.5", :group => :development
  gem "hpricot", ">= 0.8.6", :group => :development
  gem "ruby_parser", ">= 2.3.1", :group => :development
  gem "capistrano"
end

group :test do
  gem "shoulda-matchers"
  gem "capybara", ">= 1.1.2"
  gem "email_spec", ">= 1.2.1"
  gem "database_cleaner"
end

group :development, :test do
  gem "rspec-rails", ">= 2.11.0"
  gem "factory_girl_rails", ">= 4.1.0", :group => [:development, :test]
end