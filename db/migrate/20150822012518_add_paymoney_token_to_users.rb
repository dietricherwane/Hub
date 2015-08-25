class AddPaymoneyTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :paymoney_token, :string
  end
end
