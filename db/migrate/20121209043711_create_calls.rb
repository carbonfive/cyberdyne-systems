class CreateCalls < ActiveRecord::Migration
  def change
    create_table :calls do |t|
      t.string :state
      t.references :user
      t.string :phone_number
      t.string :call_sid

      t.timestamps
    end
  end
end
