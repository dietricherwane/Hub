class CreateEcommerces < ActiveRecord::Migration
  def change
    create_table :ecommerces do |t|
      t.string :name, limit: 100
      t.string :url, limit: 150
      t.text :description
      t.integer :bank_id
      t.string :pdt_url, limit: 150
      t.string :ipn_url, limit: 15
      t.string :order_already_paid_url, limit: 150

      t.timestamps
    end
  end
end
