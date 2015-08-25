class AddCertifiedAgentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :certified_agent_id, :string
  end
end
