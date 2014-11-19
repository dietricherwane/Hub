class AddValidationFieldsToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :qualified, :boolean
    add_column :ecommerces, :qualified_by, :integer
    add_column :ecommerces, :qualified_at, :datetime
    add_column :ecommerces, :unqualified_by, :integer
    add_column :ecommerces, :unqualified_at, :datetime
  end
end
