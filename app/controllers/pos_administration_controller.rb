class PosAdministrationController < ApplicationController
  before_filter :sign_out_disabled_users

  def list_agents
    @agents = User.where("certified_agent_id IS NOT NULL")
  end
end
