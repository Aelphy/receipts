FactoryGirl.define do
  factory :item do
    association :receipt
    association :currency
    association :amount_type
    name { |n| "product_#{n}" }
    price 100_500
    amount 1
  end
end
