class AddTokenToEcommerceProfiles < ActiveRecord::Migration
  def change
    add_column :ecommerce_profiles, :token, :string
  end
end
