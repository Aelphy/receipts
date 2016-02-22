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

  describe '#create' do
    let(:receipt) { create :receipt, :with_items }
    let(:receipt_user) { create :receipt_user, receipt: receipt }

    it 'marks all the items as marked' do
      receipt_user.receipt.items.each do |item|
        item_user = ItemUser.find_by(user_id: receipt_user.user.id,
                                     item_id: item.id)
        expect(item_user.status).to eq('checked')
      end
    end

    it { expect(receipt_user.user.item_users.count).to eq(2) }
  end

  describe '#destroy' do
    let(:receipt) { create :receipt, :with_items }
    let(:receipt_user) { create :receipt_user, receipt: receipt }

    before { receipt_user.destroy }

    it { expect(receipt_user.user.item_users.count).to eq(0) }
  end
end
