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
end
