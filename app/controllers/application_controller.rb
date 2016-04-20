class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def layout_used
	  case (current_user.profile_shortcut rescue "")
      when "ADMIN"
	      "administrator"
	    when "MER"
	      "merchant"
	    when "POSM"
	      "posm"
	    else
	      "session"
      end
  end

  # Overwriting the sign_out redirect path method
	def after_sign_out_path_for(resource_or_scope)
		root_path
	end

	def after_sign_in_path_for(resource_or_scope)
	  if (current_user.merchant? rescue false)
		  merchant_ecommerce_path
		else
		  if (current_user.admin? rescue false)
		    ecommerces_waiting_qualification_path
		  else
		    if (current_user.posm? rescue false)
		      posm_index_path
                    else
		      root_path
		    end
		  end
		end
	end

def after_resetting_password_path_for(resource_or_scope)
	  if (current_user.merchant? rescue false)
		  merchant_ecommerce_path
		else
		  if (current_user.admin? rescue false)
		    ecommerces_waiting_qualification_path
		  else
		    if (current_user.posm? rescue false)
		      posm_index_path
                    else
                      root_path
                    end
		  end
		end
	end

	def sign_out_disabled_users
    if (current_user.published rescue nil) == false
      sign_out(current_user)
      flash[:notice] = "Votre compte a été désactivé. Veuillez contacter l'administrateur."
      redirect_to new_user_session_path
    end
  end

  # Only merchants can access those functions
  def user_is_merchant?
    if (!current_user.merchant? rescue true)
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def user_is_admin?
    if (!current_user.admin? rescue true)
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  # Check if the parameter is not a number
  def not_a_number?(n)
  	n.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? true : false
  end
end
