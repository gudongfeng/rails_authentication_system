class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @user = User.from_omniauth(request.env['omniauth.auth'], current_user)
    sign_in_and_redirect @user
  end

  def failure
    super
  end

  alias_method :wechat, :all
end
