class AddQualificationEmailSentAndCreatedInBackOfficeToEcommerces < ActiveRecord::Migration
  def change
    add_column :ecommerces, :qualification_email_sent, :boolean
    add_column :ecommerces, :created_in_back_office, :boolean
  end
end
