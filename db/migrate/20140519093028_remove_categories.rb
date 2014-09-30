class RemoveCategories < ActiveRecord::Migration
  def up
    remove_column :rewards, :category_id
    drop_table :categories
  end

  def down
    create_table :categories do |t|
      t.string :name

      t.timestamps
    end
    add_column :rewards, :category_id, :integer
    add_index :rewards, :category_id
  end
end
