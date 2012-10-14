class AddOauthFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :github_profile, :string
    add_column :users, :facebook_profile, :string
    add_column :users, :oauth_one_time_token, :string
    add_column :users, :photo, :string
  end
end
