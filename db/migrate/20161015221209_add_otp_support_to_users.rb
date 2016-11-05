class AddOtpSupportToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :otp_activation_status, :boolean, :default => false
    add_column :users, :otp_code, :string
    add_column :users, :otp_code_activation_time, :datetime
    add_column :users, :otp_attempts_count, :integer, :default => 0
  end
end
