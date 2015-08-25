class AddErrorFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :error_code, :string
    add_column :users, :error_message, :text
  end
end
