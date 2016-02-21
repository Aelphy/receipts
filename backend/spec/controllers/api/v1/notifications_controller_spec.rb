require 'rails_helper'

RSpec.describe Api::V1::NotificationsController, type: :controller do
  let(:session) { create :session }

  before do
    request.env['HTTPS'] = 'on'
    auth = auth_data(session.token, session_id: session.id)
    set_auth_header(auth)
  end

  describe '#index' do
    context 'when there are less than 25 notifications' do
      let!(:receipt_notification) do
        create :receipt_invitation, user_id: session.user_id
      end
      let!(:debt_notification) do
        create :receipt_invitation, user_id: session.user_id
      end

      before { get :index }

      it 'assigns @notifications' do
        expect(assigns(:notifications)).to eq([debt_notification,
                                               receipt_notification])
      end
    end

    context 'when there are more than 25 notifications' do
      before do
        create_list(:receipt_invitation, 26, user_id: session.user_id)
        get :index
      end

      it { expect(assigns(:notifications).size).to eq(25) }
    end
  end
end
