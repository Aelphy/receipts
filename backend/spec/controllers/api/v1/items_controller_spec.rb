require 'rails_helper'

RSpec.describe Api::V1::ItemsController, type: :controller do
  let(:session) { create :session }

  before do
    request.env['HTTPS'] = 'on'
    auth = auth_data(session.token, session_id: session.id)
    set_auth_header(auth)
  end

  describe 'GET #index' do
    let(:receipt) { create :receipt, :with_items }

    context 'when receipt exists' do
      context 'when there are less than 25 notifications' do
        before { get :index, receipt_id: receipt.id }

        it 'assigns @notifications' do
          expect(assigns(:items)).to eq(receipt.items.order(:name))
        end
      end

     pending 'uncomment when pagination will be turned on'
        # context 'when there are more than 25 notifications' do
        #   before do
        #     create_list(:item, 26, receipt: receipt)
        #     get :index
        #   end
        #
        #   it { expect(assigns(:items).size).to eq(25) }
        # end
    end

    context 'when receipt does not exist' do
      before { get :index, receipt_id: -1 }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to include('receipt', 'was not found') }
    end
  end

  describe 'POST #create' do
    let(:receipt) { create :receipt }
    let(:item_attributes) { FactoryGirl.build(:item).attributes }

    context 'when receipt exists' do
      context 'with valid attributes' do
        it 'creates a new item' do
          expect do
            post :create, item_attributes.merge(receipt_id: receipt.id)
          end.to change { Item.count }.by(1)
        end

        it 'responds with 200 status-code' do
          post :create, item_attributes.merge(receipt_id: receipt.id)

          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid attributes' do
        before { item_attributes.delete('amount_type_id') }

        it 'does not create a new item' do
          expect do
            post :create, item_attributes.merge(receipt_id: receipt.id)
          end.not_to change { Item.count }
        end

        it 'responds with 400 status-code' do
          post :create, item_attributes.merge(receipt_id: receipt.id)

          expect(response).to have_http_status(:bad_request)
          expect(response.body).to include('amount_type_id', "can't be blank")
        end
      end
    end

    context 'when receipt does not exist' do
      before { get :index, item_attributes.merge(receipt_id: -1) }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to include('receipt', 'was not found') }
    end
  end

  pending 'uncomment when support of show action will be turned on'
    # describe '#show' do
    #
    # end

  describe 'PUT #update' do
    let(:receipt) { create :receipt }
    let(:item) { create :item, receipt: receipt }

    context 'when receipt exists' do
      context 'when item exists' do

        context 'with valid attributes' do
          before do
            put :update, {id: item.id, name: 'pr'}.merge(receipt_id: receipt.id)
          end

          it { expect(response).to have_http_status(:ok) }
        end

        context 'with invalid attributes' do
          before do
            put :update, {id: item.id, name: ''}.merge(receipt_id: receipt.id)
          end

          it { expect(response).to have_http_status(:bad_request) }
          it { expect(response.body).to include('name', "can't be blank") }
        end
      end

      context 'when item does not exist' do
        before do
          put :update, {id: -1, name: 'pr'}.merge(receipt_id: receipt.id)
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.body).to include('item', 'not found') }
      end
    end

    context 'when receipt does not exist' do
      before do
        put :update, {id: item.id, name: 'pr'}.merge(receipt_id: -1)
      end

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to include('receipt', 'was not found') }
    end
  end

  describe 'DELETE #delete' do
    let(:receipt) { create :receipt }
    let(:item) { create :item, receipt: receipt }

    context 'when receipt exists' do
      context 'when item exists' do
        before { delete :delete, {id: item.id}.merge(receipt_id: receipt.id) }

        it { expect(response).to have_http_status(:ok) }
        it { expect(Item.count).to eq(0) }
      end

      context 'when item does not exist' do
        before { delete :delete, {id: -1}.merge(receipt_id: receipt.id) }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.body).to include('item', 'was not found') }
      end
    end

    context 'when receipt does not exist' do
      before { delete :delete, {id:  item.id}.merge(receipt_id: -1) }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to include('receipt', 'was not found') }
    end
  end
end
