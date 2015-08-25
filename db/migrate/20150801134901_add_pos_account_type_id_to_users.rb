class AddPosAccountTypeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pos_account_type_id, :integer
  end
end
