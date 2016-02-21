class User < ActiveRecord::Base
  has_many :group_users
  has_many :item_users
  has_many :currency_users
  has_many :items,                       through: :item_users,
                                         dependent: :destroy
  has_many :currencies,                  through: :currency_users,
                                         dependent: :destroy
  has_many :income_receipt_invitations,  class_name: 'ReceiptInvitation',
                                         foreign_key: 'participant_id',
                                         dependent: :destroy
  has_many :outcome_receipt_invitations, class_name: 'ReceiptInvitation',
                                         foreign_key: 'inviter_id',
                                         dependent: :destroy
  has_many :notifications,               dependent: :destroy
  has_many :sessions,                    dependent: :destroy

  before_validation :set_default_fields, on: :create

  validates :phone, phony_plausible: true, presence: true, uniqueness: true
  validates :encrypted_password, presence: true
  validates :login_count, presence: true
  validates :failed_login_count, presence: true

  phony_normalize :phone, default_country_code: 'RU'

  # Public: generate new password,
  #         encrypt it and set to user,
  #         than return password value to method caller
  #
  # Returns: String
  def new_password!
    password = (Settings.security.password_length).times.map { rand(0..9) }
    password = password.join('')
    self.encrypted_password = BCrypt::Password.create(password)

    password
  end

  private

  def set_default_fields
    self.failed_login_count ||= 0
    self.login_count ||= 0
  end
end
