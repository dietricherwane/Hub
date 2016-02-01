class CreateCompensationModes < ActiveRecord::Migration
  def change
    create_table :compensation_modes do |t|
      t.string :description
      t.string :shortcut
      t.boolean :published

      t.timestamps
    end
  end
end
