class AddSubCertifiedAgentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sub_certified_agent_id, :string
  end
end
