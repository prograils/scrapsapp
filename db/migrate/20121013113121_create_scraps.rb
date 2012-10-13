class CreateScraps < ActiveRecord::Migration
  def change
    create_table :scraps do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.references :user
      t.references :organization
      t.boolean :is_public, :default=>false

      t.timestamps
    end
    add_index :scraps, :user_id
    add_index :scraps, :organization_id
    add_index :scraps, [:slug, :organization_id], :unique=>true
  end
end
