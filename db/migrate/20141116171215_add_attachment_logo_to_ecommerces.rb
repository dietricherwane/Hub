class AddAttachmentLogoToEcommerces < ActiveRecord::Migration
  def self.up
    change_table :ecommerces do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :ecommerces, :logo
  end
end
