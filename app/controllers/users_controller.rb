class UsersController < ApplicationController
  layout :layout_used

  def select_sign_in_profile
    @connection_active = "active"
  end

  def select_sign_up_profile
    @registration_active = "active"
  end
end
