require 'rails_helper'

RSpec.describe CurrencyUser, type: :model do
  let(:currency_user) { create :currency_user }

  it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  it { is_expected.to have_db_column(:currency_id).of_type(:integer) }

  it { expect(currency_user).to validate_presence_of(:user_id) }
  it { expect(currency_user).to validate_presence_of(:currency_id) }

  it { expect(currency_user).to validate_uniqueness_of(:user_id).scoped_to(:currency_id) }
  it { expect(currency_user).to validate_uniqueness_of(:currency_id).scoped_to(:user_id) }
end
