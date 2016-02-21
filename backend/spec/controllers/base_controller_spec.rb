require 'rails_helper'

RSpec.describe BaseController, type: :controller do
  controller do
    def index
      head :ok
    end
  end

  let(:session) { create :session }
  let(:invalid_param) { 'azaza' }

  context 'when token was passed' do
    context 'when session was passed' do
      context 'when session exists' do
        context 'when token is correct' do
          context 'when session is fresh' do
            let(:auth) { auth_data(session.token, session_id: session.id) }

            before do
              set_auth_header(auth)
              get :index
            end

            it { expect(response).to have_http_status(:ok) }
          end

          context 'when session is not fresh' do
            let(:old_ip) { '127.0.0.1' }
            let(:new_ip) { '192.168.0.1' }
            let(:session) { create :session, expired_at: time, current_sign_in_ip: old_ip }
            let(:auth) { auth_data(session.token, session_id: session.id) }

            before do
              set_auth_header(auth)
              allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(new_ip)
              Timecop.freeze(Time.now.utc)
              get :index
            end

            after { Timecop.return }

            context 'when token refresh period has not gone' do
              let(:time) { Time.now.utc - Settings.security.auth.token_refresh_period + 1.minute }
              let(:new_expiration_datetime) { Time.now.utc + Settings.security.auth.token_ttl }

              it { expect(response).to have_http_status(:ok) }
              it { expect(session.reload.current_sign_in_ip).to eq(new_ip) }
              it { expect(session.reload.expired_at.to_s).to eq(new_expiration_datetime.utc.to_s) }
              it { expect(controller.current_user).to eq(session.user) }
            end

            context 'when token refresh period has gone' do
              let(:time) { Time.now.utc - Settings.security.auth.token_refresh_period - 1.minute }

              it { expect(response).to have_http_status(:unauthorized) }
              it { expect(response.body).to include('token', 'is completely expired') }
              it { expect(Session.count).to eq(0) }
              it { expect(controller.current_user).to be_nil }
            end
          end
        end

        context 'when token is incorrect' do
          let(:auth) { auth_data(invalid_param, session_id: session.id) }

          before do
            set_auth_header(auth)
            get :index
          end

          it { expect(response).to have_http_status(:unauthorized) }
          it { expect(response.body).to include('token', 'is invalid') }
          it { expect(controller.current_user).to be_nil }
        end
      end

      context 'when session does not exist' do
        let(:auth) { auth_data(invalid_param, session_id: invalid_param) }

        before do
          set_auth_header(auth)
          get :index
        end

        it { expect(response).to have_http_status(:not_found) }
        it { expect(response.body).to include('session', 'was not found') }
        it { expect(controller.current_user).to be_nil }
      end
    end

    context 'when session was not passed' do
      let(:auth) { auth_data(session.token) }

      before do
        set_auth_header(auth)
        get :index
      end

      it { expect(response).to have_http_status(:bad_request) }
      it { expect(response.body).to include('session_id', 'required') }
      it { expect(controller.current_user).to be_nil }
    end
  end

  context 'when token was not passed' do
    before { get :index }

    it { expect(response).to have_http_status(:bad_request) }
    it { expect(response.body).to include('token', 'required') }
    it { expect(controller.current_user).to be_nil }
  end
end
