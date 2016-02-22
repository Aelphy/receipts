# TODO: add logic to work only when the receipt is not closed
class ReceiptUser < ActiveRecord::Base
  belongs_to :receipt
  belongs_to :user

  validates :receipt_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true, uniqueness: { scope: :receipt_id }

  after_create :mark_items
  after_destroy :uncheck_items

  private

  def mark_items
    receipt.items.each do |item|
      user.item_users.create(item_id: item.id, status: :checked)
    end
  end

  def uncheck_items
    user.item_users.where(item_id: receipt.items.pluck(:id)).delete_all
  end
end
