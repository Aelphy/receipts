FactoryGirl.define do
  factory :receipt do
    association :creditor, factory: :user
    association :currency
    shop_name { |n| "shop_#{n}" }
    discount 0
    total_price 100_500
    status { Receipt.statuses.keys.sample }

    trait :with_images do
      after_create do |receipt, evaluator|
        create_list(:receipt_image, 2, receipt_id: receipt.id)
      end
    end

    trait :with_items do
      after(:create) do |receipt, evaluator|
        create_list(:item, 2, receipt: receipt)
      end
    end
  end
end
