class SessionsCleanupJob < ActiveJob::Base
  queue_as :default

  def perform
    Session.where('expired_at < ?', Time.now.utc + Settings.security.auth.token_refresh_period).delete_all
  end
end
