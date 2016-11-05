
Devise.setup do |config|

  config.mailer_sender = 'admin@your-domain.com'
  require 'devise/orm/active_record'
  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 10
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..72
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.authentication_keys = [:phone]
  config.scoped_views = true

  config.omniauth :wechat, Figaro.env.wechat_app_id, Figaro.env.wechat_secret
  config.warden { |manager| manager.failure_app = DeviseFailure }
end
