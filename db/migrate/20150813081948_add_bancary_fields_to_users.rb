class AddBancaryFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bank_code, :string
    add_column :users, :wicket_code, :string
    add_column :users, :account_number, :string
  end
end
