module Api
  module V1
    class ReceiptsController < BaseController
      def index
      end

      def create
      end

      def show
      end

      def update
      end

      def delete
      end

      private

      def permitted_params
        params.permit(:creditor_id,
                      :currency_id,
                      :shop_name,
                      :status,
                      :discount,
                      :total_price,
                      receipt_images_attributes: [:photo, :_destroy],
                      items_attributes: [:name,
                                         :price,
                                         :currency_id,
                                         :amount,
                                         :amount_type_id,
                                         :_destroy])
      end
    end
  end
end
