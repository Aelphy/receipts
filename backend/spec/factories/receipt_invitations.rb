FactoryGirl.define do
  factory :receipt_invitation do
    association :user, factory: :user_with_currency
    association :receipt
    status :confirmed
  end
end
