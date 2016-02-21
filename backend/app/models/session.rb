class Session < ActiveRecord::Base
  belongs_to :user

  before_validation :set_expiration_time
  before_validation :generate_authentication_token

  validates :token, presence: true, length: { is: 88 }
  validates :user_id, presence: true
  validates :expired_at, presence: true

  before_create :update_user_sign_in_api
  after_create :update_user_stats
  before_update :update_user_sign_in_api, if: :current_sign_in_ip_changed?

  private

  def update_user_stats
    old_current = user.current_sign_in_at
    new_current = Time.now.utc
    user.last_sign_in_at     = old_current || new_current
    user.current_sign_in_at  = new_current

    user.failed_login_count = 0

    user.save(validate: false)
  end

  def update_user_sign_in_api
    old_current = user.current_sign_in_ip
    new_current = current_sign_in_ip
    user.last_sign_in_ip     = old_current || new_current
    user.current_sign_in_ip  = new_current

    user.save(validate: false)
  end

  def generate_authentication_token
    return if token

    loop do
      self.token = SecureRandom.base64(64)
      break unless Session.find_by(token: token)
    end
  end

  def set_expiration_time
    self.expired_at ||= Time.now.utc + (Settings.security
                                                .auth
                                                .token_ttl).minutes
  end
end
