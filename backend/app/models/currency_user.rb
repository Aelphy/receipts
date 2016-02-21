class CurrencyUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :currency

  validates :user_id, presence: true, uniqueness: { scope: :currency_id }
  validates :currency_id, presence: true, uniqueness: { scope: :user_id }
end
