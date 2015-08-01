class ChangeRequalifiedFieldInEcommerces < ActiveRecord::Migration
  def change
    remove_column :ecommerces, :requelified_by
    add_column :ecommerces, :requalified_by, :integer
  end
end
