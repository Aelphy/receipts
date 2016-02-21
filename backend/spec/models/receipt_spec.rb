require 'rails_helper'

RSpec.describe Receipt, type: :model do
  let(:receipt) { create :receipt }

  it { is_expected.to have_db_column(:creditor_id).of_type(:integer) }
  it { is_expected.to have_db_column(:shop_name).of_type(:string) }
  it { is_expected.to have_db_column(:status).of_type(:integer) }
  it { is_expected.to have_db_column(:discount).of_type(:float) }
  it { is_expected.to have_db_column(:total_price).of_type(:integer) }
  it { is_expected.to have_db_column(:currency_id).of_type(:integer) }

  it { expect(receipt).to validate_presence_of(:creditor_id) }
  it { expect(receipt).to validate_presence_of(:status) }
  it { expect(receipt).to validate_presence_of(:discount) }
  it { expect(receipt).to validate_presence_of(:total_price) }
  it { expect(receipt).to validate_presence_of(:currency_id) }

  it { expect(receipt).to validate_numericality_of(:total_price).is_greater_than(0) }
  it { expect(receipt).to validate_numericality_of(:discount).is_greater_than_or_equal_to(0) }

  it { expect(receipt).to validate_length_of(:shop_name).is_at_most(100) }
end
