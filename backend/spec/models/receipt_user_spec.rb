require 'rails_helper'

RSpec.describe ReceiptUser, type: :model do
  let(:receipt_user) { create :receipt_user }

  it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  it { is_expected.to have_db_column(:receipt_id).of_type(:integer) }

  it { expect(receipt_user).to validate_presence_of(:user_id) }
  it { expect(receipt_user).to validate_presence_of(:receipt_id) }

  it do
    expect(receipt_user).to validate_uniqueness_of(:user_id)
      .scoped_to(:receipt_id)
  end

  it do
    expect(receipt_user).to validate_uniqueness_of(:receipt_id)
      .scoped_to(:user_id)
  end
end
