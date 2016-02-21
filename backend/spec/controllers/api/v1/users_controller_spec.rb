require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before do
    request.env['HTTPS'] = 'on'
    allow(SendMessageJob).to receive(:perform_later)
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:user_attributes) { FactoryGirl.attributes_for(:user) }

      it 'creates a new user' do
        expect { post :create, user_attributes }.to change { User.count }.by(1)
      end

      it 'sends the password to user' do
        expect(SendMessageJob).to receive(:perform_later)

        post :create, user_attributes
      end

      it 'responds with 200 status-code' do
        post :create, user_attributes

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid attributes' do
      context 'when phone is duplicate' do
        let!(:user) { create :user }
        let(:user_attributes) { FactoryGirl.attributes_for(:user) }
        let(:wrong_user_attributes) { user_attributes.merge(phone: user.phone) }

        before { post :create, wrong_user_attributes }

        it { expect(User.count).to eq(1) }
        it { expect(response).to have_http_status(:bad_request) }
        it { expect(response.body).to include('has already been taken') }
      end
    end
  end

  describe 'POST #new_password' do
    context 'when phone was not passed' do
      before { post :new_password }

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.body).to include('phone', 'required') }
    end

    context 'when user does not exist' do
      let(:phone) { '79998020050' }

      before { post :new_password, phone: phone }

      it { expect(response).to have_http_status(:not_found) }
      it { expect(response.body).to include('user', 'was not found') }
    end

    context 'when valid attributes' do
      let(:old_password) { '1111' }
      let(:old_encrypted_password) { BCrypt::Password.create(old_password) }
      let(:user) { create :user, encrypted_password: old_encrypted_password }

      it 'sends new password' do
        expect(SendMessageJob).to receive(:perform_later)

        post :new_password, phone: user.phone
      end

      it 'generates new password for user' do
        post :new_password, phone: user.phone

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
