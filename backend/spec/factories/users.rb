FactoryGirl.define do
  factory :user do
    sequence :phone do |n|
      num = 7 * 10**10 + n
      num.to_s
    end

    login_count 0
    failed_login_count 0
    encrypted_password 'encrypted password'
  end

  factory :user_with_currency, parent: :user do
    transient do
      currency { create(:currency) }
    end

    after(:create) do |user, evaluator|
      create_list(:currency_user, 1, currency: evaluator.currency, user: user)
    end
  end
end
