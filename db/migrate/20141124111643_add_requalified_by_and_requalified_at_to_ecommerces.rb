class AddRequalifiedByAndRequalifiedAtToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :requelified_by, :integer
    add_column :ecommerces, :requalified_at, :datetime
  end
end
