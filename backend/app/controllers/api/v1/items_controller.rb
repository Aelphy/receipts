module Api
  module V1
    class ItemsController < BaseController
      before_filter :set_receipt
      before_filter :check_authority, except: [:index, :show]

      def index
        @items = @receipt.items.order(:name) # TODO: add this due to efficientcy considerations .page(params[:page])
      end

      def create
        @item = @receipt.items.new(permitted_params)

        if @item.save
          render_ok
        else
          render_error_code(:bad_request, :db_failure, @item.errors)
        end
      end

      # TODO: uncomment when necessary
      # def show
      #   @item = @receipt.items.find_by(id: params[:id])
      #
      #   unless @item
      #     return render_error_code(:not_found,
      #                              :db_failure,
      #                              item: 'was not found')
      #   end
      # end

      def update
        @item = @receipt.items.find_by(id: params[:id])

        unless @item
          return render_error_code(:not_found,
                                   :db_failure,
                                   item: 'was not found')
        end

        if @item.update(permitted_params)
          render_ok
        else
          render_error_code(:bad_request, :db_failure, @item.errors)
        end
      end

      def delete
        @item = @receipt.items.find_by(id: params[:id])

        unless @item
          return render_error_code(:not_found,
                                   :db_failure,
                                   item: 'was not found')
        end

        @item.destroy
        render_ok
      end

      private

      def permitted_params
        params.permit(:name, :price, :currency_id, :amount, :amount_type_id)
      end

      def set_receipt
        @receipt = Receipt.find_by(id: params[:receipt_id])

        unless @receipt
          return render_error_code(:not_found,
                                   :db_failure,
                                   receipt: 'was not found')
        end
      end

      def check_authority
        unless has_authority
          return render_error_code(:unauthorized,
                                   :no_permission,
                                   receipt: 'no rights to change this receipt')
        end
      end

      def has_authority
        @receipt.users.pluck(:id).include?(current_user.id) ||
          @receipt.creditor_id == current_user.id
      end
    end
  end
end
