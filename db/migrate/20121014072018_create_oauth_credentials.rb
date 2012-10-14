class CreateOauthCredentials < ActiveRecord::Migration
  def change
    create_table :oauth_credentials do |t|
      t.string :provider
      t.string :uid
      t.text :params
      t.references :user

      t.timestamps
    end
    add_index :oauth_credentials, :user_id
  end
end
