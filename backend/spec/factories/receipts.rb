FactoryGirl.define do
  factory :receipt do
    association :creditor, factory: :user
    association :currency
    shop_name { |n| "shop_#{n}" }
    discount 0
    total_price 100_500
    status { Receipt.statuses.keys.sample }
  end
end
