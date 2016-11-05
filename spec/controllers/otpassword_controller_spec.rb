require 'rails_helper'

RSpec.describe Users::OtpasswordController, type: :controller do
  describe 'GET #show' do
    it 'returns http success' do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #activate' do
    login_user_unactivated

    it 'redirect to users_otpassword_show without parameters' do
      process :activate, method: :post
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(users_otpassword_show_path)
    end

    it 'redirect to users_otpassword_show with invalid code' do
      process :activate, method: :post, params: { code: 123456 }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(users_otpassword_show_path)
    end

    it 'redirect to users_otpassword_show with valid code' do
      @user.update_attributes otp_code: 1234
      process :activate, method: :post, params: { code: 1234 }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(user_path @user)
    end

    it 'redirect to new_user_session_path for activated user' do
      @user.update_attributes otp_activation_status: true
      process :activate, method: :post, params: { code: 1234 }
      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
