class CreateStars < ActiveRecord::Migration
  def change
    create_table :stars do |t|
      t.references :user
      t.references :scrap

      t.timestamps
    end
    add_index :stars, :user_id
    add_index :stars, :scrap_id
  end
end
