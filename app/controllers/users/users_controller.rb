class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :validate_user, only: [:show]

  # to allow using wechat, wechat_oauth2 in controller and wechat_config_js in view
  wechat_api

  def show
    # print t '.success'
  end

  def new
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      if @user.send_otp_code?
        redirect_to controller: 'users/otpassword', action: 'show'
      else
        flash[:notice] = t '.fail'
        redirect_to controller: 'users/otpassword', action: 'show'
      end
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone, :email, :country_code)
  end
end