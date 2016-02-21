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

  describe '#create' do
    it { expect(receipt_invitation.pending?).to be_truthy }
  end

  describe '#update' do
    before do
      ReceiptUser.create(user_id: receipt_invitation.user_id,
                         receipt_id: receipt_invitation.reference_id)
    end

    context 'when declined' do
      before { receipt_invitation.update(status: :declined) }

      it 'destroys existing receipt user' do
         expect(
             ReceiptUser.where(receipt_id: receipt_invitation.reference_id,
                               user_id: receipt_invitation.user_id).count
         ).to eq(0)
      end
    end

    context 'when confirmed' do
      before { receipt_invitation.update(status: :confirmed) }

      it 'does nothing with existing receipt user' do
         expect(
             ReceiptUser.where(receipt_id: receipt_invitation.reference_id,
                               user_id: receipt_invitation.user_id).count
         ).to eq(1)
      end
    end
  end
end
