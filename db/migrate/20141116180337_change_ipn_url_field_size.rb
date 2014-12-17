class ChangeIpnUrlFieldSize < ActiveRecord::Migration
  def change
    remove_column :ecommerces, :ipn_url
    add_column :ecommerces, :ipn_url, :string, limit: 150
  end
end
