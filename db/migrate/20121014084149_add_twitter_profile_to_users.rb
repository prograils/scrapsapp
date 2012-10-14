class AddTwitterProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_profile, :string
  end
end
