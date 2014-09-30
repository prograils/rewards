class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :description
      t.integer :reward_id
      t.integer :user_id

      t.timestamps
    end

    add_index :comments, :reward_id
    add_index :comments, :user_id
  end
end
