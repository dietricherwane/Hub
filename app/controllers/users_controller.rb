class UsersController < ApplicationController
  layout :layout_used

  def select_sign_in_profile
    @connection_active = "active"
  end

  def select_sign_up_profile
    @registration_active = "active"
  end

  def has_rib
    certified_agent_id = params[:certified_agent_id]
    status = ""
    (User.where(certified_agent_id: certified_agent_id, sub_certified_agent_id: nil).first.rib rescue nil).blank? ? status = "0" : status = "1"

    render text: status
  end
end
