class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :comment_body
      t.references :commentable, polymorphic: true
      t.references :user

      t.timestamps
    end
    add_index :comments, [:commentable_type, :commentable_id]
  end
end
