class AddWariSubCertifiedAgentIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wari_sub_certified_agent_id, :string
  end
end
