module Api
  module V1
    class UsersController < ApplicationController
      include UsersHelper

      def create
        @user = User.new(permitted_params)
        password = @user.new_password!

        if @user.save
          SendMessageJob.perform_later(@user.phone, sign_up_message(password))
          render_ok
        else
          render_error_code(:bad_request, :db_failure, @user.errors)
        end
      end

      def new_password
        unless params[:phone]
          return render_error_code(:bad_request,
                                   :parameter_missing,
                                   phone: 'required')
        end

        @user = User.find_by(phone: PhonyRails.normalize_number(params[:phone]))

        unless @user
          return render_error_code(:not_found,
                                   :db_failure,
                                   user: 'was not found')
        end

        new_password = @user.new_password!

        if @user.save
          SendMessageJob.perform_later(@user.phone, new_password_message(new_password))
          render_ok
        else
          render_error_code(:bad_request, :db_failure, @user.errors)
        end
      end

      private

      def permitted_params
        params.permit(:phone, :name, :email)
      end
    end
  end
end
