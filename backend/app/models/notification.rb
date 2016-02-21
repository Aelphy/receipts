class Notification < ActiveRecord::Base
  belongs_to :user

  before_validation :set_default_status, if: :new_record?

  validates :user_id, presence: true
  validates :reference_id, presence: true
  validates :status, presence: true

  private

  def set_default_status
    fail NotImplementedError
  end
end
