class AddPosAccountTypeIdToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :pos_account_type_id, :integer
  end
end
