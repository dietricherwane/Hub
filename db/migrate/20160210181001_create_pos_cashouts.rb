class CreatePosCashouts < ActiveRecord::Migration
  def change
    create_table :pos_cashouts do |t|
      t.integer :user_id
      t.string :amount
      t.string :fee
      t.string :thumb
      t.string :transaction_id
      t.text :request_body
      t.text :request_response

      t.timestamps
    end
  end
end
