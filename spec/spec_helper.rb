require 'omniauth'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

OmniAuth.config.test_mode = true
OmniAuth.config.mock_auth[:wechat] = OmniAuth::AuthHash.new({
    'provider' => 'wechat',
    'uid' => '123545',
    'info' => {
        'nickname' => 'mock_name',
        'avatar' => 'mock_user_thumbnail_url',
        'sex' => 'male'
    },
    'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
    }
})
