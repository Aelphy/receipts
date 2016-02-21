require 'rails_helper'

RSpec.describe ReceiptInvitation, type: :model do
  let(:receipt_invitation) { create :receipt_invitation }

  it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  it { is_expected.to have_db_column(:author_id).of_type(:integer) }
  it { is_expected.to have_db_column(:message).of_type(:text) }
  it { is_expected.to have_db_column(:status).of_type(:integer) }
  it { is_expected.to have_db_column(:reference_id).of_type(:integer) }

  it { expect(receipt_invitation).to validate_presence_of(:user_id) }
  it { expect(receipt_invitation).to validate_presence_of(:reference_id) }
  it { expect(receipt_invitation).to validate_presence_of(:status) }

  it { expect(create :receipt_invitation, status: ReceiptInvitation.statuses.keys.sample).to be_valid }
  it { expect { create :receipt_invitation, status: 'wrong status' }.to raise_error(ArgumentError) }
end
