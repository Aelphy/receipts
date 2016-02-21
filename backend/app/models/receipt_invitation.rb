class ReceiptInvitation < Notification
  enum status: [:confirmed, :pending, :declined]

  belongs_to :receipt, foreign_key: 'reference_id'
  belongs_to :inviter, foreign_key: 'author_id', class_name: 'User'

  after_update :process_receipt_user, if: :status_changed?

  private

  def set_default_status
    self.status = :pending
  end

  # Internal: destroy the connection between user and receipt if declined
  #
  # It cannot be that initial status was not pending.
  # It assumes, that before creation of invitation it was created the connection
  #   between the user and receipt (ReceiptUser)
  #
  # Returns: Boolean
  def process_receipt_user
    raise LogicViolation unless changes[:status][0] == 'pending'

    if status_changed?(to: 'declined')
      ReceiptUser.find_by(receipt_id: reference_id, user_id: user_id).destroy
    end
  end
end
