FactoryGirl.define do
  factory :currency_user do
    association :user
    association :currency
  end
end
