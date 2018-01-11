class AddEcommerceProfileIdToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :ecommerce_profile_id, :integer
  end
end
