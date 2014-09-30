class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.string :description
      t.integer :value
      t.boolean :is_archived, default: false
      t.integer :category_id
      t.integer :giver_id
      t.integer :recipient_id

      t.timestamps
    end
    add_index :rewards, :category_id
    add_index :rewards, :giver_id
    add_index :rewards, :recipient_id
  end
end
