class AddFirstnameAndLastnameToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :firstname, :string
    add_column :ecommerces, :lastname, :string
  end
end
