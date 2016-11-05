require 'rails_helper'

RSpec.describe SendSmsJob, type: :job do
  describe '#Perform' do
    it 'successfully send the message' do
      user = create(:user)
      user.update_attributes otp_code: 1234
      SendSmsJob.perform_now user.country_code, user.phone, user.otp_code
    end
  end
end
