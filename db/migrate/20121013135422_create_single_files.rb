class CreateSingleFiles < ActiveRecord::Migration
  def change
    create_table :single_files do |t|
      t.string :name
      t.string :file_name
      t.string :directory
      t.text :content
      t.string :lexer
      t.string :lexer_type
      t.references :scrap

      t.timestamps
    end
    add_index :single_files, :scrap_id
  end
end
