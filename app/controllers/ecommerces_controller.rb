class EcommercesController < ApplicationController
  prepend_before_filter :authenticate_user!, except: [:get_logo]
  before_filter :sign_out_disabled_users, except: [:get_logo]
  before_filter :user_is_merchant?, only: [:index, :create, :edit, :update]
  before_filter :user_is_admin?, only: [:waiting_qualification, :available_wallets, :enable_wallet, :disable_wallet, :get_wallets_per_country, :qualify, :admin_successful_transactions_per_wallet, :admin_failed_transactions_per_wallet]
  before_filter :merchant_has_ecommerce?, only: [:index, :create]

  layout :layout_used

  def index
    @ecommerce = Ecommerce.new
    initialize_form
  end

  def create
    @ecommerce = Ecommerce.new(params[:ecommerce].merge(user_id: current_user.id, token: generate_token))
    initialize_form

    if @ecommerce.save
      link_to_wallets
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
    @ecommerce_template = @ecommerce
    parameters = Parameter.first

    if @ecommerce.nil?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @id = @ecommerce.id
      initialize_form

      request = Typhoeus::Request.new("#{parameters.back_office_url}/service/update", params: {service_token: @ecommerce.token,url_on_success: params[:ecommerce][:pdt_url], url_on_error: params[:ecommerce][:pdt_url], url_to_ipn: params[:ecommerce][:ipn_url], url_on_basket_already_paid: params[:ecommerce][:order_already_paid_url], authentication_token: "7a57b200d5be13837de15874300b16ee"}, method: :get, followlocation: true)
      request.run

      if @ecommerce.update(params[:ecommerce].except(fields_to_except)) && request.response = "f26e0312bd863867f4f1e6b83483644b"
        initialize_template
        flash.now[:success] = "Les informations relatives au Ecommerce ont été mises à jour."
      else
        flash.now[:error] = @ecommerce.errors.full_messages.map { |msg| "<p>#{msg}</p>" }.join
      end

      render :edit
    end
  end

  # List the wallets per country for merchants
  def merchant_list_wallets_per_country
    ecommerce_token = current_user.ecommerces.first.token rescue ""
    parameters = Parameter.first

    request = Typhoeus::Request.new("#{parameters.back_office_url}/wallets/used_per_country/#{ecommerce_token}", method: :post, followlocation: true)
    request.run

    @wallets_per_countries = (JSON.parse(request.response.body) rescue nil)
  end

  def merchant_successful_transactions_per_wallet
    generic_merchant_transactions_per_wallet(params[:authentication_token], 'successful_transactions')
  end

  def merchant_failed_transactions_per_wallet
    generic_merchant_transactions_per_wallet(params[:authentication_token], 'failed_transactions')
  end

  def generic_merchant_transactions_per_wallet(authentication_token, url)
    parameters = Parameter.first
    ecommerce_token = current_user.ecommerces.first.token rescue ""
    @wallet = Wallet.find_by_authentication_token(authentication_token)

    request = Typhoeus::Request.new("#{parameters.back_office_url}/wallet/#{url}/#{ecommerce_token}/#{authentication_token}", method: :post, followlocation: true)
    request.run

    @transactions = (JSON.parse(%Q/#{request.response.body}/))
  end

  def initialize_form
    @banks = Bank.where(published: [nil, true])
    @ecommerce_active = "active"
  end

  def initialize_template
    @ecommerce_template = Ecommerce.find_by_id(@id)
  end

  # Links Ecommerce to available wallets after creation
  def link_to_wallets
    wallets = Wallet.where(published: true)
    unless wallets.empty?
      wallets.each do |wallet|
        wallet.available_wallets.create(ecommerce_id: @ecommerce.id, published: true)
      end
    end
  end

  # Sends a notification email to the business unit in charge of validations
  def qualification_submission_email(user, bank, ecommerce)
    Thread.new do
      Notification.qualification_submission(user, bank, ecommerce).deliver
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
    return [:url, :bank_id, :rib, :user_id, :name]
  end

  ############# Actions for admins #############

  # List Ecommerces waiting for qalification
  def waiting_qualification
    @ecommerces = Ecommerce.where(qualified: nil).page(params[:page])
    @ecommerce_active = "active"
  end

  # List qualified Ecommerces
  def qualified
    @ecommerces = Ecommerce.where(qualified: true, published: [nil, true]).page(params[:page])
    initialize_admin_ecommerces_menu
  end

  # List disabled Ecommerces
  def disabled
    @ecommerces = Ecommerce.where(qualified: true, published: false).page(params[:page])
    initialize_admin_ecommerces_menu
  end

  # Define available wallets for a given Ecommerce
  def available_wallets
    @ecommerce = Ecommerce.find_by_id(params[:ecommerce_id])
    if @ecommerce
      get_wallets_per_country
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  # Enables a wallet for a given ecommerce
  def enable_wallet
    enable_disable_wallet(params[:available_wallet_id], true, "activé")
  end

  # Disables a wallet for a given ecommerce
  def disable_wallet
    enable_disable_wallet(params[:available_wallet_id], false, "désactivé")
  end

  # Qualifies an Ecommerce
  def qualify
    parameters = Parameter.first
    ecommerce = Ecommerce.find_by_id(params[:ecommerce_id])

    if ecommerce
      request = Typhoeus::Request.new("#{parameters.back_office_url}/service/qualify", params: {name: ecommerce.name, token: ecommerce.token, pdt_url: ecommerce.pdt_url, ipn_url: ecommerce.ipn_url, order_already_paid: ecommerce.order_already_paid_url, wallets: "#{ecommerce.available_wallets.map {|m| [m.wallet.authentication_token, m.published]}}"}, method: :post, followlocation: true)
      request.run
      response = (JSON.parse(request.response.body) rescue nil)

      if response && (response["status"] rescue nil) == "6"
        ecommerce.update_attributes(service_token: response["service_token"], operation_token: response["operation_token"], qualified: true, qualified_by: current_user.id, qualified_at: DateTime.now)
        ecommerce_qualified_email(ecommerce.user, ecommerce.bank, ecommerce)
        flash[:notice] = "Le Ecommerce a été correctement qualifié."
      else
        flash[:error] = "Le Ecommerce n'a pas pu être qualifié. Veuillez contacter l'administrateur."
      end
      redirect_to ecommerces_waiting_qualification_path
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  # List ecommerces
  def transactions_list_ecommerces
    @transactions_active = 'active'
    @ecommerces = Ecommerce.where(qualified: true).page(params[:page])
  end

  # List the wallets per country for admins
  def admin_list_wallets_per_country
    @ecommerce = Ecommerce.find_by_token(params[:ecommerce_token])
    parameters = Parameter.first

    request = Typhoeus::Request.new("#{parameters.back_office_url}/wallets/used_per_country/#{@ecommerce.token}", method: :post, followlocation: true)
    request.run

    @wallets_per_countries = (JSON.parse(request.response.body) rescue nil)
  end

  def admin_successful_transactions_per_wallet
    generic_admin_transactions_per_wallet(params[:authentication_token], params[:ecommerce_token], 'successful_transactions')
  end

  def admin_failed_transactions_per_wallet
    generic_admin_transactions_per_wallet(params[:authentication_token], params[:ecommerce_token], 'failed_transactions')
  end

  def generic_admin_transactions_per_wallet(authentication_token, ecommerce_token, url)
    parameters = Parameter.first
    @wallet = Wallet.find_by_authentication_token(authentication_token)

    request = Typhoeus::Request.new("#{parameters.back_office_url}/wallet/#{url}/#{ecommerce_token}/#{authentication_token}", method: :post, followlocation: true)
    request.run

    @transactions = (JSON.parse(%Q/#{request.response.body}/) rescue nil)
  end

  def enable_disable_wallet(available_wallet_id, status, message)
    available_wallet = AvailableWallet.find_by_id(params[:available_wallet_id])

    if available_wallet
      if status
        available_wallet.update_attributes(published: status, published_by: current_user.id, published_at: DateTime.now)
      else
        available_wallet.update_attributes(published: status, unpublished_by: current_user.id, unpublished_at: DateTime.now)
      end
      @ecommerce = available_wallet.ecommerce

      enable_disable_wallet_on_back_office(available_wallet, message, status)
      get_wallets_per_country

      render :available_wallets
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  # Enables and disables a wallet for a given Ecommerce on the back office
  def enable_disable_wallet_on_back_office(available_wallet, message, status)
    parameters = Parameter.first
    if @ecommerce.qualified_at.blank?
      flash.now[:notice] = "Le wallet a été #{message}"
    else
      request = Typhoeus::Request.new("#{parameters.back_office_url}/available_wallet/enable_disable", params: {service_token: (available_wallet.ecommerce.token rescue ""), wallet_token: (available_wallet.wallet.authentication_token rescue ""), status: status}, method: :post, followlocation: true)
      request.run
      response = (JSON.parse(request.response.body) rescue nil)

      if (response["status"] rescue nil) == "2"
        flash.now[:notice] = "Le wallet a été correctement #{message}"
      else
        flash.now[:error] = "Le wallet n'a pas été correctement #{message} veuillez contacter l'administrateur"
      end
    end
  end

  # Enable an Ecommerce on the front and back offices
  def enable
    enable_disable(params[:ecommerce_id], true, "activé")
  end

  # Disable an Ecommerce on the front and back offices
  def disable
    enable_disable(params[:ecommerce_id], false, "suspendu. Les changements prendront effet dans 15 minutes.")
  end

  def enable_disable(ecommerce_id, status, message)
    @ecommerce = Ecommerce.find_by_id(params[:ecommerce_id])

    if @ecommerce
      if status
        @ecommerce.update_attributes(published: status, requalified_by: current_user.id, requalified_at: DateTime.now)
      else
        @ecommerce.update_attributes(published: status, unqualified_by: current_user.id, unqualified_at: DateTime.now)
      end

      enable_disable_on_back_office(message, status)

      if current_user.admin?
        initialize_admin_ecommerces_menu
        if status
          render :disabled
        else
          render :qualified
        end
      else
        @ecommerce_template = @ecommerce # Initialize the template on the right side
        initialize_form
        render :edit
      end
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

  def enable_disable_on_back_office(message, status)
    parameters = Parameter.first
    request = Typhoeus::Request.new("#{parameters.back_office_url}/service/enable_disable", params: {service_token: (@ecommerce.token rescue ""), status: status}, method: :post, followlocation: true)
    request.run
    response = (JSON.parse(request.response.body) rescue nil)

    if (response["status"] rescue nil) == "1"
      flash.now[:notice] = "Le Ecommerce a été correctement #{message}"
    else
      flash.now[:error] = "Le Ecommerce n'a pas été correctement #{message} veuillez contacter l'administrateur"
    end
  end

  def get_wallets_per_country
    parameters = Parameter.first
    request = Typhoeus::Request.new("#{parameters.back_office_url}/wallets/available", method: :post, followlocation: true)
    request.run
    response = (request.response.body rescue nil)

    @wallets_per_countries = (JSON.parse(response) rescue nil)
  end

  def get_logo
    ecommerce = Ecommerce.find_by_token(params[:token])

    if ecommerce
      render text: ecommerce.logo.url(:hub)
    else
      render text: "images/medium/missing.png"
    end
  end

  def initialize_admin_ecommerces_menu
    @ecommerce_active = "active"
  end

  # ############# End actions for admins #############

  # Before filters
  # Redirects the user to edit action when it has an ecommerce
  def merchant_has_ecommerce?
    @ecommerces = current_user.ecommerces
    if !@ecommerces.blank?
      redirect_to merchant_edit_ecommerce_path
    end
  end

  # Sends a notification email to the business unit in charge of validations
  def ecommerce_qualified_email(user, bank, ecommerce)
    Thread.new do
      #Notification.ecommerce_qualified(user, bank, ecommerce).deliver
      close_active_record_connection
    end
  end

  def generate_token
    begin
      token = SecureRandom.hex(6)
    end while (Ecommerce.all.map{|m| m.token}).include?(token)

    return token
  end
end
