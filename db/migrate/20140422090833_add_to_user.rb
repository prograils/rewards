class AddToUser < ActiveRecord::Migration
  def change
    add_column :users, :limit, :integer, default: 0
    add_column :users, :received_sum, :integer, default: 0
    add_column :users, :spent_sum, :integer, default: 0
  end
end
