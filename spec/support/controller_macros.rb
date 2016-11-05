module ControllerMacros
  # Test helper method for +spec/controllers/*.rb+
  # login an activated user with fake wechat authorization
  def login_user_activated
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:wechat]
      @user = create(:user_activated)
      sign_in @user
    end
  end

  # Test helper method for +spec/controllers/*.rb+
  # login an unactivated user with fake wechat authorization
  def login_user_unactivated
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:wechat]
      @user = create(:user_with_authorization)
      sign_in @user
    end
  end
end