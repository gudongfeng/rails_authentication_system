require 'rails_helper'

RSpec.feature 'User', :type => :feature do
  describe '#Sign in/Sign up' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:wechat]
    end

    it 'can redirect to otp show page with valid information' do
      # Create the valid user first with corresponding wechat omniauth information
      user = create(:user_with_authorization)
      expect(user).to be_valid
      sign_in_with_wechat
      expect(page).to have_field('code')
      expect(page).to have_button('激活')
    end

    it 'can redirect to user page with valid information and pass the otp' do
      # Create the valid user first with corresponding wechat omniauth information
      # and activated the user
      create :user_activated
      sign_in_with_wechat
      expect(current_path).to eql user_path User.first
    end

    it 'can not sign in user with incomplete information (lack of phone and email)' do
      sign_in_with_wechat
      expect(User.count).to eq(1)
      visit user_path(Authorization.find_by(uid: '123545').user.id)
      expect(current_path).to eql new_user_path
    end

    it 'can not sign in user with invalid information (invalid phone and email)' do
      sign_in_with_wechat
      expect(User.count).to eq(1)
      expect(current_path).to eql new_user_path
      fill_in_user_infos 'aslkdjfoiu', 'alskdjfjoiu', +86
      expect(page).to have_content('Email是无效的')
      expect(page).to have_content('Phone必须为数字')
    end

    it 'can redirect new user to user show page after activate the user' do
      expect(User.all.count).to eql 0
      sign_in_with_wechat
      expect(current_path).to eql new_user_path
      expect(page).to have_content 'Sign Up'
      fill_in_user_infos '99999999', 'test@test.com', '+86'
      expect(page).to have_field('code')
      expect(page).to have_button('激活')
      user = User.find_by(email: 'test@test.com')
      expect(user.otp_code).to_not be nil
      fill_in('code', with: user.otp_code)
      click_button('激活')
      expect(page).to have_content("#{user.nickname}")
      expect(User.find_by(email: 'test@test.com').otp_attempts_count).to eql 1
    end

    it 'can sign out user when at otpassword show page' do
      # Sign up the user
      sign_in_with_wechat
      fill_in_user_infos '99999999', 'test@test.com', '+86'
      # Sign out the user
      expect(page).to have_link('登出')
      click_link('登出')
      expect(current_path).to eql new_user_session_path
    end

    it 'can resend the activation code' do
      # Sign up the user
      sign_in_with_wechat
      fill_in_user_infos '99999999', 'test@test.com', '+86'
      # Resend the activation code
      expect(page).to have_link('重新发送验证码')
      click_link('重新发送验证码')
      expect(page).to have_content('成功发送新的验证码')
    end

    it 'can notify the user when activate code does not match' do
      sign_in_with_wechat
      fill_in_user_infos '99999999', 'test@test.com', '+86'
      fill_in('code', with: 123456)
      click_button('激活')
      expect(page).to have_content('验证码错误，请重试')
      expect(User.find_by(email: 'test@test.com').otp_attempts_count).to eql 1
    end

    it 'can handle authentication error' do
      OmniAuth.config.mock_auth[:wechat] = :invalid_credentials
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:wechat]
      silence_omniauth { sign_in_with_wechat }
      expect(page).to have_content 'Invalid credentials'
      expect(current_path).to eql new_user_session_path
    end
  end

  private

  def silence_omniauth
    previous_logger = OmniAuth.config.logger
    OmniAuth.config.logger = Logger.new("/dev/null")
    yield
  ensure
    OmniAuth.config.logger = previous_logger
  end

  def sign_in_with_wechat
    visit new_user_session_path
    click_link 'Sign in with Wechat'
  end

  def fill_in_user_infos phone, email, country_code
    fill_in('user[email]', with: email)
    fill_in('user[phone]', with: phone)
    fill_in('user[country_code]', with: country_code)
    click_button('Confirm')
  end
end