class CreateParameters < ActiveRecord::Migration
  def change
    create_table :parameters do |t|
      t.string :back_office_url, limit: 100

      t.timestamps
    end
  end
end
