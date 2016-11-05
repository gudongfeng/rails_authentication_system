FactoryGirl.define do
  # association factory with a 'belongs_to' association for the user
  factory :authorization do
    provider 'wechat'
    uid 123545
  end

  factory :user do
    email 'test@test.com'
    phone '99999999'
    country_code '+86'
    nickname 'mock_name'

    # create :user, :activated
    trait :activated do
      otp_activation_status true
      otp_code_activation_time Time.now
      otp_attempts_count 1
    end

    # user with wechat zuthorization but hasn't been activated
    factory :user_with_authorization do
      after(:create) do |user|
        create(:authorization, user: user)
      end
    end

    # user has been activated
    factory :user_activated, traits: [ :activated ] do
      after(:create) do |user|
        create(:authorization, user: user)
      end
    end
  end
end
