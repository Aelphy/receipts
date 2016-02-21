module Api
  module V1
    class ReceiptsController < BaseController
      def index
        # TODO: add filtering
        @receipts = current_user.receipts.order(date: :desc).page(params[:page])
      end

      def create
        receipt_images_attrs = permitted_params.delete(:receipt_images_attributes)
        items_attrs = permitted_params.delete(:items_attributes)
        participants = permitted_params.delete(:participants)

        @receipt = Receipt.new(permitted_params)
        success = true
        errors = []

        Receipt.transaction do
          if @receipt.save
            receipt_images_attrs.each do |attrs|
              receipt_image = ReceiptImage.new(attrs)

              if !receipt_image.save
                success = false
                errors << receipt_image.errors
              end
            end

            items_attrs.each do |attrs|
              item = Item.new(attrs)

              if !item.save
                success = false
                errors << item.errors
              end
            end

            participants.each do |participant_id|
              receipt_user = ReceiptUser.new(user_id: participant_id,
                                             receipt_id: @receipt.id)

              if !receipt_user.save
                success = false
                errors << receipt_user.errors
              end
            end

            participants.each do |participant_id|
              invitation = ReceiptInvitation.new(user_id: participant_id,
                                                 receipt_id: @receipt.id,
                                                 author_id: @receipt.creditor_id)

              if !invitation.save
                success = false
                errors << invitation.errors
              end
            end
          else
            success = false
            errors << @receipt.errors
          end
        end

        if success
          render_ok
        else
          render_error_code(:bad_request, :db_failure, errors)
        end
      end

      def show
        @receipt = Receipt.find_by(id: params[:id])

        unless @receipt
          return render_error_code(:not_found,
                                   :db_failure,
                                   receipt: 'was not found')
        end
      end

      def update
        permitted_params.delete(:receipt_images_attributes)
        permitted_params.delete(:items_attributes)
        permitted_params.delete(:participants)

        @receipt = Receipt.find_by(params[:id])

        unless @receipt
          return render_error_code(:not_found,
                                   :db_failure,
                                   receipt: 'was not found')
        end

        if @receipt.update(permitted_params)
          render_ok
        else
          render_error_code(:bad_request,
                            :db_failure,
                            @receipt.errors)
        end
      end

      def delete
        @receipt = Receipt.find_by(id: params[:id])

        unless @receipt
          return render_error_code(:not_found,
                                   :db_failure,
                                   receipt: 'was not found')
        end

        if current_user.id == @receipt.creditor_id
          @receipt.destroy
          render_ok
        else
          return render_error_code(:unauthorized,
                                   :no_permission,
                                   receipt: 'no rights to delete receipt')
        end
      end

      private

      def permitted_params
        params.permit(:creditor_id,
                      :currency_id,
                      :shop_name,
                      :status,
                      :discount,
                      :total_price,
                      :participants,
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
