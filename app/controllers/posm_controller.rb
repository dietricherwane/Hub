class PosmController < ApplicationController

  #prepend_before_filter :authenticate_user!#, except: [:get_logo]
  before_filter :sign_out_disabled_users#, except: [:get_logo]

  def index
    @posm_active = "active"

    request = Typhoeus::Request.new("http://94.247.178.141:8080/PAYMONEY_WALLET/rest/solte_compte/#{current_user.paymoney_account_number rescue ''}/#{current_user.paymoney_password rescue ''}", followlocation: true, method: :get)

    request.on_complete do |response|
      if response.success?
        @sold = JSON.parse(response.body) rescue ""
      end
    end

    request.run
  end

  def transactions_log
    @posm_transactions_active = "active"
    @transactions = PaymoneyWalletLog.where("agent = '#{current_user.certified_agent_id}' AND status = TRUE").order("created_at DESC")
  end

  def transaction_logs_search
    @begin_date = "#{params[:begin_date][:month]}/#{params[:begin_date][:day]}/#{params[:begin_date][:year]}"
    @end_date = "#{params[:end_date][:month]}/#{params[:end_date][:day]}/#{params[:end_date][:year]}"
    @transaction_type = params[:transaction_type]

    params[:begin_date] = @begin_date
    params[:end_date] = @end_date
    params[:transaction_type] = @transaction_type

    set_transaction_search_params

    @transactions = PaymoneyWalletLog.where("#{@sql_begin_date} #{@sql_begin_date.blank? ? '' : 'AND'} #{@sql_end_date} #{@sql_end_date.blank? ? '' : 'AND'} #{@sql_type} #{@sql_type.blank? ? '' : 'AND'} status = TRUE AND agent = '#{current_user.certified_agent_id}'").order("created_at DESC") #rescue nil

    #if @transactions.blank?
      flash[:success] = "#{@transactions.count} Résultat(s) trouvé(s)."

      if params[:commit] == "Exporter"
        send_data @transactions.to_csv, filename: "Transaction-pos-#{Date.today}.csv"
      end
    #else
      #flash[:error] = "Veuillez utiliser le sélecteur de date"
      #redirect_to transaction_logs_path
    #end
  end

  def init_form

  end

  def cashout
    @posm_cashout_active = "active"

    @pos_cashout = PosCashout.new
    cashouts_list
  end

  def proceed_cashout
    @posm_cashout_active = "active"
    transaction_amount = params[:pos_cashout][:amount]
    token = current_user.paymoney_token
    transaction_id = Digest::SHA1.hexdigest([DateTime.now.iso8601(6), rand].join).hex.to_s[0..17]
    @pos_cashout = PosCashout.new

    if not_a_number?(transaction_amount)
      flash.now[:error] = "Le montant doit être numérique."
    else
      request_body = "http://94.247.178.141:8080/PAYMONEY_WALLET/rest/virement_vers_rib/f4d0a8ab/#{token}/#{transaction_amount}/0/0/#{transaction_id}"

      request = Typhoeus::Request.new(request_body, followlocation: true, method: :get)
      request.on_complete do |response|
        if response.success?
          response_body = response.body
          if response_body == "good"
            PosCashout.create(transaction_id: transaction_id, amount: transaction_amount, user_id: current_user.id, request_body: request_body, request_response: response_body)
            flash.now[:success] = "Votre transaction a été effectuée."
          else
            flash.now[:error] = "Le transfert n'a pas été validé."
          end
        else
          flash.now[:error] = "Le transfert a été annulé."
        end
      end

      request.run
    end

    cashouts_list

    render :cashout
  end

  def cashouts_list
    token = current_user.paymoney_token
    request_body = "http://195.14.0.128:8080/LONACI_HUB_WS/rest/Consultationoperation_cash_out_rib/#{token}"

    request = Typhoeus::Request.new(request_body, followlocation: true, method: :get)
    request.on_complete do |response|
      if response.success?
        @pos_cashouts = JSON.parse(response.body) rescue ""
      end
    end

    request.run
  end

  def set_transaction_search_params
    @sql_begin_date = ""
    @sql_end_date = ""
    @sql_type = ""

    unless @begin_date.blank?
      @sql_begin_date = "created_at::date >= '#{@begin_date}'"
    end
    unless @end_date.blank?
      @sql_end_date = "created_at::date <= '#{@end_date}'"
    end
    unless @transaction_type.blank?
      @sql_type = "transaction_type = '#{@transaction_type}'"
    end
  end

end
