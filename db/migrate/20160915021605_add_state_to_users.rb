class AddStateToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :state, :string, :default => 'available'
  end
end
