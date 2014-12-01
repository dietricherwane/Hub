class AddPublishedToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :published, :boolean
  end
end
