class AddHastusIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :hastus_id, :integer
  end
end
