class CreateObservers < ActiveRecord::Migration
  def change
    create_table :observers do |t|
      t.references :user
      t.references :organization
      t.references :membership
      t.references :observed

      t.timestamps
    end
    add_index :observers, :user_id
    add_index :observers, :organization_id
    add_index :observers, :membership_id
    add_index :observers, :observed_id
  end
end
