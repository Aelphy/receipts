FactoryGirl.define do
  factory :session do
    association :user
    token do
      authentication_token = nil

      loop do
        authentication_token = SecureRandom.base64(64)
        break unless Session.find_by(token: authentication_token)
      end

      authentication_token
    end

    expired_at Time.now + 3.minutes
  end
end
