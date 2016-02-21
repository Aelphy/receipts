require 'rails_helper'

RSpec.describe AmountType, type: :model do
  let(:amount_type) { create :amount_type }

  it { is_expected.to have_db_column(:name).of_type(:string) }

  it { expect(amount_type).to validate_presence_of(:name) }
  it { expect(amount_type).to validate_uniqueness_of(:name) }
end
