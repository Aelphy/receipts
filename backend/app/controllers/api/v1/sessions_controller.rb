module Api
  module V1
    class SessionsController < ApplicationController
      def create
        return unless require_params(:phone, :password)

        @user = User.find_by(phone: PhonyRails.normalize_number(params[:phone]))

        unless @user
          return render_error_code(:not_found,
                                   :db_failure,
                                   user: 'was not found')
        end

        encrypted_password = BCrypt::Password.new(@user.encrypted_password)
        password = BCrypt::Engine.hash_secret(params[:password],
                                              encrypted_password.salt)

        unless ActiveSupport::SecurityUtils.secure_compare(encrypted_password,
                                                           password)
          @user.failed_login_count += 1
          @user.save(validate: false)

          return render_error_code(:not_found,
                                   :wrong_parameter,
                                   password: 'is invalid')
        end

        @session = @user.sessions.create(current_sign_in_ip: request.remote_ip)

        render_ok(token: @session.token)
      end

      def destroy
        token, _options = auth.token_and_options(request)

        unless token
          return render_error_code(:bad_request,
                                   :parameter_missing,
                                   token: 'required')
        end

        @session = Session.find_by(token: token)

        unless @session
          return render_error_code(:not_found,
                                   :db_failure,
                                   session: 'was not found')
        end

        @session.destroy
        render_ok
      end
    end
  end
end
