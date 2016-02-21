module Api
  module V1
    class NotificationsController < BaseController
      # TODO: think about adding a show action
      def index
        @notifications = Notification.where(user_id: current_user.id)
                                     .order(created_at: :desc)
                                     .page(params[:page])
      end
    end
  end
end
