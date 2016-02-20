require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  it { is_expected.to have_db_column(:phone).of_type(:string) }
  it { is_expected.to have_db_column(:email).of_type(:string) }
  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
  it { is_expected.to have_db_column(:login_count).of_type(:integer) }
  it { is_expected.to have_db_column(:failed_login_count).of_type(:integer) }
  it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
  it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:string) }
  it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:string) }

  it { expect(user).to validate_presence_of(:phone) }
  it { expect(user).to validate_presence_of(:encrypted_password) }
  it { expect(user).to validate_presence_of(:login_count) }
  it { expect(user).to validate_presence_of(:failed_login_count) }

  it { expect(user).to validate_presence_of(:phone) }

  it 'normalizes number' do
    user = create :user, phone: '79998020050'
    expect(user.phone).to eq('+79998020050')
  end

  describe '#new_password!' do
    let(:password) { '0000' }
    let(:encrypted_password) { BCrypt::Password.create(password) }

    before { allow_any_instance_of(User).to receive(:rand).and_return 0 }

    it 'generates new random password' do
      expect(BCrypt::Password).to receive(:create).with(password)

      user.new_password!
    end

    it 'sets new random password' do
      allow(BCrypt::Password).to receive(:create).and_return(encrypted_password)
      user.new_password!

      expect(user.encrypted_password).to eq(encrypted_password)
    end

    it 'does not save user' do
      allow(BCrypt::Password).to receive(:create).and_return(encrypted_password)
      user.new_password!

      # Note: default encrypted password value in user factory is 'encrypted password'
      expect(user.reload.encrypted_password).to eq('encrypted password')
    end

    it { expect(user.new_password!).to eq(password) }
  end
end
