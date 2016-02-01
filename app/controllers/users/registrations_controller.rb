class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  layout :layout_used

  # GET /resource/sign_up
  def new
    #@profiles = Profile.where(published: [nil, true], shortcut: "ADM")
    #@social_statuses = SocialStatus.where(published: [nil, true])
    #@users = User.where(profile_id: Profile.admin_id).page(params[:page]).per(10)
    init_form

    build_resource({})
    respond_with self.resource
  end

  def new_pos_account
    build_resource({})

    @pos_account_type = PosAccountType.where("token = 'a3fde11549ed'")

    init_form
  end

  # Create merchant pos account
  def create_pos_account
    @pos_account_type = PosAccountType.where("token = 'a3fde11549ed'")
    saved = false

    init_form

    pos_account_type = PosAccountType.find_by_id(params[:user][:pos_account_type_id])

    build_resource(params[:user].merge({profile_id: Profile.find_by_name(pos_account_type.name).id, pos_account_type_id: pos_account_type.id, company: params[:user][:company], rib: params[:user][:rib], bank_code: params[:user][:bank_code], wicket_code: params[:user][:wicket_code], account_number: params[:user][:account_number], activities_description: params[:user][:activities_description], certified_agent_id: SecureRandom.hex(8), identification_token: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join)}))

    if resource.save
      # Création de lid agent agréé sur paymoney
      if (pos_account_type.name rescue nil) == "POS marchand"
        account_type = "OTpPcVxO"
      else
        account_type = "jVUdVQBK"
      end

      puts URI.escape("#{Parameter.first.paymoney_url}/PAYMONEY_WALLET/rest/create_compte/#{account_type}/#{resource.firstname}/#{resource.lastname}/#{Date.today}/#{resource.email}/#{resource.identification_token}/#{resource.mobile_number}/#{resource.bank_code}/#{resource.wicket_code}/#{resource.account_number}/#{resource.rib}/#{resource.country.name}")

      request = Typhoeus::Request.new(URI.escape("#{Parameter.first.paymoney_url}/PAYMONEY_WALLET/rest/create_compte/#{account_type}/#{resource.firstname}/#{resource.lastname}/#{Date.today}/#{resource.email}/#{resource.identification_token}/#{resource.mobile_number}/#{resource.bank_code}/#{resource.wicket_code}/#{resource.account_number}/#{resource.rib}/#{resource.country.name}"), followlocation: true, method: :get)

      clown = resource.clone

      request.on_complete do |response|
        if response.success?
          response = JSON.parse(response.body) rescue nil
          if response.blank?
            resource.errors.add(:id, "Une erreur s'est produite, veuillez contacter l'administrateur.")
          else
            case (response["status"]["idStatus"].to_s rescue "")
              when "1"
                resource.update_attributes(created_on_paymoney_wallet: true, paymoney_account_number: response["compteNumero"], paymoney_password: response["comptePassword"], paymoney_token: response["compteLibelle"])
              when "4"
                resource.errors.add(:id, "Ce compte existe déjà.")

                clown.delete
              else
                resource.errors.add(:id, "Une erreur inconnue s'est produite, veuillez contacter l'administrateur. Statut: #{response["status"]["idStatus"].to_s rescue ""} Message: #{response["status"]["idStatus"].to_s rescue ""}")
                clown.delete
            end
          end
        else
          clown.delete
          resource.errors.add(:id, "La ressource n'est pas disponible, veuillez contacter l'administrateur.")
        end
      end

      request.run

      # Création de lid agent agréé sur paymoney wallet pour les marchands
      if ((pos_account_type.name rescue nil) == "POS marchand" ) && (resource.created_on_paymoney_wallet rescue nil) == true
        request = Typhoeus::Request.new("#{Parameter.first.paymoney_wallet_url}/api/86d138798bc43ed59e5207c68e864564/#{resource.certified_agent_id}/#{resource.paymoney_account_number}/#{resource.paymoney_token}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            if (request.response.body rescue nil) == "1"
              resource.update_attribute(:created_on_paymoney_wallet, true)
              flash.now[:success] = "Le compte a été correctement créé. "
            else

            end
          end
        end

        request.run
      end

      saved = true
    else
      clean_up_passwords resource
    end


    #render text: "#{Parameter.first.paymoney_url}/PAYMONEY_WALLET/rest/create_compte/#{account_type}/#{resource.firstname}/#{resource.lastname}/null/#{resource.email}/#{resource.identification_token}/#{resource.mobile_number}/#{resource.bank_code}/#{resource.wicket_code}/#{resource.account_number}/#{resource.rib}/#{resource.country.name}"
    if current_user.blank? && saved == true
      sign_in(resource_name, resource)
      redirect_to posm_index_path(certified_agent_id: resource.certified_agent_id)
    else
      #build_resource({})
      render :new_pos_account
    end
  end

  def new_private_pos_account
    build_resource({})

    @pos_account = User.find_by_certified_agent_id(params[:certified_agent_id])

    if @pos_account.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @pos_account_type = PosAccountType.where("token = '57d3c9d284c0'")
      init_form
    end
  end

  # Create merchant pos account
  def create_private_pos_account
    @pos_account_type = PosAccountType.where("token = '57d3c9d284c0'")
    @pos_account = User.find_by_certified_agent_id(params[:certified_agent_id])

    init_form

    pos_account_type = PosAccountType.find_by_id(params[:user][:pos_account_type_id])

    build_resource(params[:user].merge({profile_id: Profile.find_by_name(pos_account_type.name).id, pos_account_type_id: pos_account_type.id, company: params[:user][:company], rib: params[:user][:rib], bank_code: params[:user][:bank_code], wicket_code: params[:user][:wicket_code], account_number: params[:user][:account_number], activities_description: params[:user][:activities_description], certified_agent_id: params[:certified_agent_id], sub_certified_agent_id: SecureRandom.hex(9), identification_token: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join), password: "password", password_confirmation: "password"}))

    if resource.save
=begin
      # Création de lid agent agréé sur paymoney
      if (pos_account_type.name rescue nil) == "POS marchand"
        account_type = "OTpPcVxO"
      else
        account_type = "jVUdVQBK"
      end

      request = Typhoeus::Request.new(URI.escape("#{Parameter.first.paymoney_url}/PAYMONEY_WALLET/rest/create_compte_pariculier/#{account_type}/#{resource.firstname}/#{resource.lastname}/#{Date.today}/#{resource.email}/#{resource.identification_token}/#{resource.mobile_number}/nulll/nulll/nullllllllll/nu/#{@pos_account.paymoney_token}/#{resource.country.name}"), followlocation: true, method: :get)

      clown = resource.clone

      request.on_complete do |response|
        if response.success?
          response = JSON.parse(response.body) #rescue nil
          if response.blank?
            resource.errors.add(:id, "Une erreur s'est produite, veuillez contacter l'administrateur.")
          else
            case (response["status"]["idStatus"].to_s rescue "")
              when "1"
                resource.update_attributes(created_on_paymoney_wallet: true, paymoney_account_number: response["compteNumero"], paymoney_password: response["comptePassword"], paymoney_token: response["compteLibelle"])
              when "4"
                resource.errors.add(:id, "Ce compte existe déjà.")

                clown.delete
              else
                resource.errors.add(:id, "Une erreur inconnue s'est produite, veuillez contacter l'administrateur. Statut: #{response["status"]["idStatus"].to_s rescue ""} Message: #{response["status"]["idStatus"].to_s rescue ""}")
                clown.delete
            end
          end
        else
          clown.delete
          resource.errors.add(:id, "La ressource n'est pas disponible, veuillez contacter l'administrateur.")
        end
      end

      request.run
=end

      # Création de lid agent agréé sur paymoney wallet pour les marchands
      if ((pos_account_type.name rescue nil) == "POS particulier" ) && (resource.created_on_paymoney_wallet rescue nil) == true
        request = Typhoeus::Request.new("#{Parameter.first.paymoney_wallet_url}/api/86d138798bc43ed59e5207c68e864564/#{resource.certified_agent_id}/#{resource.sub_certified_agent_id}/#{resource.paymoney_account_number}/#{resource.paymoney_token}", followlocation: true, method: :get)

        request.on_complete do |response|
          if response.success?
            if (request.response.body rescue nil) == "1"
              resource.update_attribute(:created_on_paymoney_wallet, true)
              flash.now[:success] = "Le compte a été correctement créé. "
              build_resource({})
            else
            end
          end
        end

        request.run
      end
    else
      clean_up_passwords resource
    end


    #render text: "#{Parameter.first.paymoney_url}/PAYMONEY_WALLET/rest/create_compte/#{account_type}/#{resource.firstname}/#{resource.lastname}/null/#{resource.email}/#{resource.identification_token}/#{resource.mobile_number}/#{resource.bank_code}/#{resource.wicket_code}/#{resource.account_number}/#{resource.rib}/#{resource.country.name}"
    render :new_private_pos_account
  end

  def api_create_wari_private_pos
    mobile_number = params[:phone_number]
    wari_sub_certified_agent_id = params[:wari_sub_certified_agent_id]
    email = "#{Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join)[0..10]}@wari.com"
    status = '0'
    pos_account = User.find_by_certified_agent_id('e24624454e6f0cd5')

    wari_private_pos = User.new(firstname: 'Wari', lastname: 'Wari', profile_id: Profile.find_by_shortcut('POSP').id, pos_account_type_id: PosAccountType.find_by_token('57d3c9d284c0').id, country_id: Country.find_by_code('CIV').id, mobile_number: mobile_number, company: 'Wari', rib: 'nu', bank_code: 'nulll', wicket_code: 'nulll', account_number: 'nullllllllll', certified_agent_id: '92305fc3bb2d66f2', sub_certified_agent_id: SecureRandom.hex(9), identification_token: Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join), email: email, password: 'wariprivatepos', password_confirmation: 'wariprivatepos', address: 'None', wari_sub_certified_agent_id: wari_sub_certified_agent_id)

    if wari_private_pos.save
      request = Typhoeus::Request.new(URI.escape("#{Parameter.first.paymoney_url}/PAYMONEY_WALLET/rest/create_compte_pariculier/jVUdVQBK/#{wari_private_pos.firstname}/#{wari_private_pos.lastname}/#{Date.today}/#{wari_private_pos.email}/#{wari_private_pos.identification_token}/#{wari_private_pos.mobile_number}/nulll/nulll/nullllllllll/nu/#{pos_account.paymoney_token}/#{wari_private_pos.country.name}"), followlocation: true, method: :get)

      request.on_complete do |response|
        if response.success?
          response = JSON.parse(response.body) rescue nil
          if !response.blank?
            if (response["status"]["idStatus"].to_s rescue "") == "1"
              wari_private_pos.update_attributes(created_on_paymoney_wallet: true, paymoney_account_number: response["compteNumero"], paymoney_password: response["comptePassword"], paymoney_token: response["compteLibelle"])

              status = '1'

            else
              wari_private_pos.delete
            end
          end
        else
          wari_private_pos.delete
        end
      end

      request.run
    end

    # Create the private pos on paymoney wallet
    #if !(status == '1' )
    if !(status == '1' && create_sub_certified_agent_id_on_paymoney_wallet(wari_private_pos))
      status = '0'
      wari_private_pos.delete
    end

    render text: status
  end

  # Create sub certified agent id on Paymoney Wallet
  def create_sub_certified_agent_id_on_paymoney_wallet(wari_private_pos)
    response = (RestClient.get "#{Parameter.first.paymoney_wallet_url}/api/86d138798bc43ed59e5207c68e864564/#{wari_private_pos.certified_agent_id}/#{wari_private_pos.sub_certified_agent_id}/#{wari_private_pos.wari_sub_certified_agent_id}/#{wari_private_pos.paymoney_account_number}/#{wari_private_pos.paymoney_token}" rescue nil)
    response_status = false

    if (response.body rescue nil) == '1'
      wari_private_pos.update_attribute(:created_on_paymoney_wallet, true)
      response_status = true
    end

    return response_status
  end

  def list_merchant_pos_account
    @pos_list = "active"
    @merchant_pos_accounts = PosAccountType.find_by_token("a3fde11549ed").users.order("created_at DESC").page(params[:page])
  end

  def list_private_pos_account
    @pos_list = "active"
    @merchant_pos_account = User.find_by_certified_agent_id(params[:certified_agent_id])

    if @merchant_pos_account.blank?
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    else
      @private_pos_accounts = User.where("certified_agent_id = '#{params[:certified_agent_id]}' AND  sub_certified_agent_id IS NOT NULL AND sub_certified_agent_id <> ''").order("created_at DESC").page(params[:page])
    end
  end

  def store_error_code(error_code, error_message)
    #resource.update_attributes()
  end

  # POST /resource
  def create
    init_form

    build_resource(params[:user].merge({profile_id: Profile.find_by_shortcut("MER").id}))
    #build_resource(sign_up_params)

    if resource.save
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_up(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        #flash[:notice] = "Le compte de l'utilisateur a été créé. Il va recevoir un email contenant un lien sur lequel il devra cliquer pour activer son compte."
        #if current_user.merchant?
		      #redirect_to merchant_ecommerce_path
		    #end
        #redirect_to admin_dashboard_path
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    init_form

    render :edit
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    init_form

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    if resource.update_with_password(account_update_params)
      if is_navigational_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      sign_in resource_name, resource, :bypass => true
      respond_with resource, :location => after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  # DELETE /resource
  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed if is_navigational_format?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  def cancel
    expire_session_data_after_sign_in!
    redirect_to new_registration_path(resource_name)
  end

  def init_form
    @countries = Country.all
    @compensation_modes = CompensationMode.all
    @pos_active = "active"
  end

  protected

  def update_needs_confirmation?(resource, previous)
    resource.respond_to?(:pending_reconfirmation?) &&
      resource.pending_reconfirmation? &&
      previous != resource.unconfirmed_email
  end

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash=nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    after_sign_in_path_for(resource)
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    respond_to?(:root_path) ? root_path : "/"
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    signed_in_root_path(resource)
  end

  # Authenticates the current scope and gets the current resource from the session.
  def authenticate_scope!
    send(:"authenticate_#{resource_name}!", :force => true)
    self.resource = send(:"current_#{resource_name}")
  end

  def sign_up_params
    devise_parameter_sanitizer.for(:sign_up)
  end

  def account_update_params
    devise_parameter_sanitizer.for(:account_update)
  end
end
