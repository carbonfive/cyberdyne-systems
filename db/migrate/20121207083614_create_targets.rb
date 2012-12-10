class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.string :name
      t.string :email
      t.string :phone_number
      t.boolean :priority

      t.timestamps
    end
  end
end
