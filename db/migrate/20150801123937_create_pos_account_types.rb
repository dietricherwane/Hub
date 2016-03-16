class CreatePosAccountTypes < ActiveRecord::Migration
  def change
    create_table :pos_account_types do |t|
      t.string :name
      t.string :token

      t.timestamps
    end
  end
end
