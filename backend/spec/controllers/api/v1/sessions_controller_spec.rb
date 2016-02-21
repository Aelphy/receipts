require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  before { request.env['HTTPS'] = 'on' }

  describe 'POST #create' do
    let(:password) { '0000' }
    let(:phone) { '79998020050' }
    before { post :create, params }

    context 'when phone was not passed' do
      let(:params) { {} }

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.body).to include('phone', 'required') }
    end

    context 'when password was not passed' do
      let(:params) { { phone: phone } }

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.body).to include('password', 'required') }
    end

    context 'when user with given phone does not exist' do
      let(:params) { { phone: phone, password: password } }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to include('user', 'was not found') }
    end

    context 'when user with given phone exists' do
      let(:wrong_password) { '11111' }
      let(:user) { create :user, encrypted_password: BCrypt::Password.create(password) }

      context 'when password is correct' do
        let(:params) { { phone: user.phone, password: password } }

        it { expect(response).to have_http_status(:ok) }
        it { expect(response.body).to include('token') }
      end

      context 'when password is incorrect' do
        let(:params) { { phone: user.phone, password: wrong_password } }

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.body).to include('password', 'is invalid') }
        it { expect(user.reload.failed_login_count).to eq(1) }
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when token was not provided' do
      before { delete :destroy }

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.body).to include('token', 'required') }
    end

    context 'when token was provided' do
      context 'when token is correct' do
        let(:session) { create :session }
        let(:auth) {  auth_data(session.token) }

        before do
          set_auth_header(auth)
          delete :destroy
        end

        it { expect(response).to have_http_status(:ok) }
        it { expect { Session.count == 0 } }
      end

      context 'when token is incorrect' do
        let(:another_token) { '1' * 88 }
        let(:session) { create :session }
        let(:auth) {  auth_data(another_token) }

        before do
          session
          set_auth_header(auth)
          delete :destroy
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.body).to include('session', 'was not found') }
      end
    end
  end
end
