class AddFieldsToLogs < ActiveRecord::Migration
  def change
    add_column :logs, :object_inspector, :text
    add_column :logs, :request_log, :text
    add_column :logs, :response_log, :text
  end
end
