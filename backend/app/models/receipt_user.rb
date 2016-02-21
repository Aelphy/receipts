class ReceiptUser < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :user

  validates :receipt_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true, uniqueness: { scope: :receipt_id }
end
