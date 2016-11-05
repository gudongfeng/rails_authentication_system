class SendSmsJob < ApplicationJob
  queue_as :default

  def perform country_code, phone, otp_code
    url = Figaro.env.yunpian_sms_url
    apikey = Figaro.env.yunpian_apikey

    text = I18n.t 'jobs.send_sms.text', code: otp_code
    mobile = "#{country_code.gsub('+', '%2B') if country_code != '+86'}#{phone}"
    HTTP.headers(:accept => "application/json",
                 'Content-Type': 'application/x-www-form-urlencoded')
        .post(url, :body => "apikey=#{apikey}&text=#{text}&mobile=#{mobile}")
  end
end
