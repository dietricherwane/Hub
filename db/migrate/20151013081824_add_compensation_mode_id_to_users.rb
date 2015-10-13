class AddCompensationModeIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :compensation_mode_id, :integer
  end
end
