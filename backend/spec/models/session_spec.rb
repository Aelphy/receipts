require 'rails_helper'

RSpec.describe Session, type: :model do
  let(:session) { create :session }

  it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  it { is_expected.to have_db_column(:expired_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:token).of_type(:string) }

  it { expect(session).to validate_presence_of(:user_id) }

  it { expect(session).to validate_length_of(:token).is_equal_to(88) }

  context 'when created' do
    it 'should generate token' do
      session_without_token = build :session, token: nil

      session_without_token.save

      expect { session_without_token.token.present? }
    end

    let(:old_ip) { '127.0.0.1' }
    let(:new_ip) { '192.168.0.1' }
    let(:current_time) { Time.now.utc }
    let(:user) do
      create :user, current_sign_in_at: current_time,
                    last_sign_in_at: current_time - 5.minutes,
                    current_sign_in_ip: old_ip,
                    failed_login_count: 2
    end
    let(:session) { create :session, user: user, current_sign_in_ip: new_ip }

    it 'should update sign in statistics of user' do
      user

      Timecop.freeze(current_time + 5.minutes)

      session

      Timecop.return

      expect { user.last_sign_in_at == current_time - 5.minutes && user.current_sign_in_at == current_time + 5.minutes }
    end

    it 'should reset failed login count of user' do
      user
      session

      expect(user.failed_login_count).to eq(0)
    end

    it 'should update user sign in ip statistics' do
      user
      session

      expect { user.current_sign_in_ip = new_ip }
    end

    it 'should set the expiration time' do
      expect { session.expired_at == current_time + (Settings.security.auth.token_ttl).minutes }
    end
  end

  context 'when updated' do
    let(:old_ip) { '127.0.0.1' }

    context 'when session ip has been changed' do
      let(:new_ip) { '192.168.0.1' }
      let(:user) { create :user, current_sign_in_ip: old_ip }
      let(:session) { create :session, user: user, current_sign_in_ip: new_ip }

      it 'should update user sign in ip statistics' do
        user
        session

        expect { user.current_sign_in_ip == new_ip && user.last_sign_in_ip == old_ip }
      end
    end

    context 'when session ip was not changed' do
      let(:last_user_ip) { '192.168.0.1' }
      let(:user) { create :user, current_sign_in_ip: old_ip, last_sign_in_ip: last_user_ip }
      let(:session) { create :session, user: user, current_sign_in_ip: old_ip }

      it 'should not touch user sign in ip statistics' do
        user
        session

        expect { user.current_sign_in_ip == old_ip && user.last_sign_in_ip == last_user_ip }
      end
    end
  end
end
