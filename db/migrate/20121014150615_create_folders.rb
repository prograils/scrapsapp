class CreateFolders < ActiveRecord::Migration
  def change
    create_table :folders do |t|
      t.string :name
      t.string :slug
      t.references :organization

      t.timestamps
    end
    add_index :folders, :organization_id
    add_index :folders, :slug, :unique=>true
    add_column :scraps, :folder_id, :integer
    add_index :scraps, :folder_id
  end
end
