class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend: true

  # ==========================================================================
  # CALLBACK
  # ==========================================================================

  before_action :set_locale

  # ==========================================================================
  # HELPER METHODS
  # ==========================================================================

  def new_session_path(scope)
    new_user_session_path
  end

  protected

  def after_sign_in_path_for(resource)
    # return the path based on resource
    user_path current_user
  end

  def after_sign_out_path_for(resource)
    # return to the user sign in path
    new_user_session_path
  end

  def validate_user
    if !current_user.valid?
      redirect_to new_user_path
    elsif !current_user.otp_validate?
      redirect_to users_otpassword_show_path
    end
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
