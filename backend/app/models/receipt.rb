class Receipt < ActiveRecord::Base
  enum status: [:open, :archived]

  has_many :items, dependent: :destroy

  belongs_to :creditor, class_name: 'User'
  belongs_to :currency

  validates :creditor_id, presence: true
  validates :currency_id, presence: true
  validates :shop_name, length: { maximum: 100 }
  validates :status, presence: true
  validates :discount, presence: true,
                       numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
end
