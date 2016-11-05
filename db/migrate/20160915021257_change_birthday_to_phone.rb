class ChangeBirthdayToPhone < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :birthday, :string
    rename_column :users, :birthday, :phone
  end
end
