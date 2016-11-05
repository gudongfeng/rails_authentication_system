class DeviseFailure < Devise::FailureApp
  def redirect_url
    new_user_session_path
  end
end
