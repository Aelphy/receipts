FactoryGirl.define do
  factory :currency do
    name { |i| "currency_#{i}" }
    exchange_rate 1
  end
end
