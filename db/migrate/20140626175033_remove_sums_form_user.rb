class RemoveSumsFormUser < ActiveRecord::Migration
  def up
    remove_column :users, :received_sum
    remove_column :users, :spent_sum
  end

  def down
    add_column :users, :received_sum, :integer
    add_column :users, :spent_sum, :integer
  end
end
