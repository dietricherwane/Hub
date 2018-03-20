class PosAdministrationController < ApplicationController
  before_filter :sign_out_disabled_users

  layout :layout_used

  def list_agents
    @agents = User.where("certified_agent_id IS NOT NULL AND pos_account_type_id = #{PosAccountType.find_by_name('POS marchand').id}")
  end

  def list_agent_transactions
    @agent = User.where("certified_agent_id = ?", params[:agent_id]).first rescue nil
    if @agent.blank?
      redirect_to pos_administration_list_agents_path
    else
      @transactions = PaymoneyWalletLog.where("agent = ? AND status = TRUE", @agent.certified_agent_id).order("created_at DESC")
    end
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
