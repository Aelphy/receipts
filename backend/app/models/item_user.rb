class ItemUser < ActiveRecord::Base
  enum status: [:checked, :unchecked]

  belongs_to :item
  belongs_to :user

  validates :item_id, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true, uniqueness: { scope: :item_id }
  validates :status, presence: true
end
