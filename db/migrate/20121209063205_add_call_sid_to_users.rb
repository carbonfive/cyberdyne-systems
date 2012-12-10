class AddCallSidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :call_sid, :string
  end
end
