class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, limit: 255
      t.boolean :published

      t.timestamps
    end
  end
end
