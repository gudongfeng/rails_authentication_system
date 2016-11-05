class Users::OtpasswordController < ApplicationController

  # Pass the +params[:code]+ , activate the user according to the correctness
  # of the code
  def activate
    if !current_user.otp_activation_status
      if !current_user.otp_code.nil?
        # increment the otp attempt count
        current_user.increment! :otp_attempts_count

        if current_user.otp_code == params[:code]
          if current_user.update_attributes otp_code: nil,
                                            otp_activation_status: true,
                                            otp_code_activation_time: Time.now
            redirect_to user_path current_user
          else
            flash[:notice] = t '.fail'
            redirect_to users_otpassword_show_path
          end
        else
          flash[:notice] = t '.match'
          redirect_to users_otpassword_show_path
        end
      else
        flash[:notice] = t '.error'
        redirect_to users_otpassword_show_path
      end
    else
      flash[:notice] = t '.activated'
      redirect_to new_user_session_path
    end
  end

  # Resend the code
  def resend_code
    if current_user.send_otp_code?
      flash[:notice] = t '.success'
    else
      flash[:notice] = t '.fail'
    end
    render :show
  end
end
