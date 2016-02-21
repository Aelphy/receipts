# TODO: think about images for items and about separate currencies. It could be that one receipt was paid using several currencies
class Item < ActiveRecord::Base
  has_many :item_users
  has_many :users, through: :item_users, dependent: :destroy

  belongs_to :receipt
  belongs_to :amount_type
  belongs_to :currency

  validates :receipt_id, presence: true
  validates :currency_id, presence: true
  validates :amount_type_id, presence: true
  validates :name, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true,
                    numericality: { greater_than_or_equal_to: 0 }
end
