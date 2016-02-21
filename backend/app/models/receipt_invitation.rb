class ReceiptInvitation < Notification
  enum status: [:confirmed, :pending, :declined]

  belongs_to :receipt, foreign_key: 'reference_id'
  belongs_to :inviter, foreign_key: 'author_id', class_name: 'User'

  private

  def set_default_status
    self.status = :pending
  end
end
