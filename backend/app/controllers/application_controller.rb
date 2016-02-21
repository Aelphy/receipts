class ApplicationController < ActionController::API
  include ActionController::MimeResponds

  # TODO: turn on to force SSL
  # force_ssl

  before_action :handle_options_request

  # TODO: remove development codes in production mode
  def render_error_code(http_code, internal_error_code, errors = nil)
    payload = { message: ErrorCode.instance.message(internal_error_code),
                code: ErrorCode.instance[internal_error_code],
                errors: errors }
    render json: payload, status: http_code
  end

  def render_ok(payload = nil)
    render json: payload, status: :ok
  end

  private

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end

  # Internal: wrapper around ActionController::HttpAuthentication::Token
  #
  # Returns: Module
  def auth
    ActionController::HttpAuthentication::Token
  end

  # Internal: checks whether request contains necessary keys
  #
  # keys - any number of Symbols, required keys
  #
  # Returns: Boolean
  def require_params(*keys)
    keys.each do |param|
      unless params[param]
        render_error_code(:bad_request,
                          :parameter_missing,
                          param => 'required')

        return false
      end
    end

    true
  end
end
