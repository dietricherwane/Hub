class PosmController < ApplicationController

  #prepend_before_filter :authenticate_user!#, except: [:get_logo]
  before_filter :sign_out_disabled_users#, except: [:get_logo]

  def index
    @posm_active = "active"
  end

  def transactions_log
    @posm_transactions_active = "active"
    @transactions = PaymoneyWalletLog.where("agent = '#{current_user.certified_agent_id}'").order("created_at DESC")
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

end
