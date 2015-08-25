class AddAdditionalFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activities_description, :text
    add_column :users, :rib, :string, limit: 24
  end
end
