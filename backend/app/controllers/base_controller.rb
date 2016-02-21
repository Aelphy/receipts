class BaseController < ApplicationController
  before_action :authenticate_user_from_token!

  attr_reader :current_user

  private

  def authenticate_user_from_token!
    token, options = auth.token_and_options(request)

    unless token.present?
      return render_error_code(:bad_request,
                               :parameter_missing,
                               token: 'required')
    end

    unless options.present?
      return render_error_code(:bad_request,
                               :parameter_missing,
                               session_id: 'required')
    end

    session = Session.find_by(id: options[:session_id])

    unless session
      return render_error_code(:not_found,
                               :db_failure,
                               session: 'was not found')
    end

    unless ActiveSupport::SecurityUtils.secure_compare(session.token, token)
      return render_error_code(:unauthorized,
                               :wrong_parameter,
                               token: 'is invalid')
    end

    @current_session = session
    @current_user = @current_session.user
    current_time = Time.now.utc

    return if @current_session.expired_at > current_time

    if @current_session.expired_at + Settings.security.auth.token_refresh_period > current_time
      @current_session.expired_at = current_time + Settings.security.auth.token_ttl
      update_current_ip
    else
      @current_user = nil
      @current_session.destroy
      return render_error_code(:unauthorized,
                               :wrong_parameter,
                               token: 'is completely expired')
    end

    update_current_ip
  end

  def update_current_ip
    @current_session.current_sign_in_ip = request.remote_ip
    @current_session.save(validate: false)
  end
end
