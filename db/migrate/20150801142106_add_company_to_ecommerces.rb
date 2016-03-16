class AddCompanyToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :company, :string
  end
end
