FactoryGirl.define do
  factory :item_user do
    association :item
    association :user
    status { ItemUser.statuses.keys.sample }
  end
end
