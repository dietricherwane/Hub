class AddCanCashoutToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_cashout_to_rib, :boolean
  end
end
