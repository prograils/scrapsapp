class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :slug
      t.references :user

      t.timestamps
    end
    add_index :organizations, :slug, :unique=>true
    add_index :organizations, :user_id
  end
end
