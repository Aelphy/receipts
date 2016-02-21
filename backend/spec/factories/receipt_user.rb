FactoryGirl.define do
  factory :receipt_user do
    association :user
    association :receipt
  end
end
