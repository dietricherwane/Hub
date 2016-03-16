class AddIdentificationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :identification_token, :string
  end
end
