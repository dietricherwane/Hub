class HomeController < ApplicationController
  layout :layout_used

  def home

  end

  def contact
    @contact_active = 'active'
  end
end
