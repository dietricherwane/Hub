class EcommercesController < ApplicationController
  prepend_before_filter :authenticate_user!
  before_filter :sign_out_disabled_users
  before_filter :user_is_merchant?, only: [:index, :create, :edit, :update]
  before_filter :merchant_has_ecommerce?, only: [:index, :create]

  layout :layout_used

  def index
    @ecommerce = Ecommerce.new
    initialize_form
  end

  def create
    @ecommerce = Ecommerce.new(params[:ecommerce].merge(user_id: current_user.id))
    initialize_form

    if @ecommerce.save
      qualification_submission_email(current_user, @ecommerce.bank, @ecommerce)
      flash[:success] = "Votre demande de qualification a été soumise. Elle sera étudiée et l'état de sa validation vous sera notifié."
      redirect_to merchant_edit_ecommerce_path
    else
      flash.now[:error] = @ecommerce.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      render :index
    end
  end

  def edit
    @ecommerce = current_user.ecommerces.first
    @ecommerce_template = @ecommerce # Initialize the template on the right side
    initialize_form
  end

  def update
    @ecommerce = current_user.ecommerces.first rescue nil

    if @ecommerce.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @id = @ecommerce.id
      initialize_form

      if @ecommerce.update(params[:ecommerce].except(fields_to_except))
        initialize_template
        flash.now[:success] = "Les informations relatives au Ecommerce ont été mises à jour."
      else
        flash.now[:error] = @ecommerce.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end

      render :edit
    end
  end

  def initialize_form
    @banks = Bank.where(published: [nil, true])
    @ecommerce_active = "active"
  end

  def initialize_template
    @ecommerce_template = Ecommerce.find_by_id(@id)
  end

  # Sends a notification email to the business unit in charge of validations
  def qualification_submission_email(user, bank, ecommerce)
    Thread.new do
      #Notification.qualification_submission(user, bank, ecommerce).deliver
      ecommerce.update_attribute(:qualification_email_sent, true)
      close_active_record_connection
    end
  end

  # Close connections opened by threads
  def close_active_record_connection
    if (ActiveRecord::Base.connection && ActiveRecord::Base.connection.active?)
      ActiveRecord::Base.connection.close
    end
  end

  def fields_to_except
    return [:url, :bank_id, :rib, :user_id]
  end

  # Actions for admins
  def waiting_qualification
    @ecommerces = Ecommerce.where(qualified: nil).page(params[:page])
    @ecommerce_active = "active"
  end
  # End actions for admins

  # Before filters
  # Redirects the user to edit action when it has an ecommerce
  def merchant_has_ecommerce?
    @ecommerces = current_user.ecommerces
    if !@ecommerces.blank?
      redirect_to merchant_edit_ecommerce_path
    end
  end

  # Only merchants can access those functions
  def user_is_merchant?
    if (!current_user.merchant? rescue true)
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end
end
