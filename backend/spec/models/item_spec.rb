require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:item) { create :item }

  it { is_expected.to have_db_column(:receipt_id).of_type(:integer) }
  it { is_expected.to have_db_column(:currency_id).of_type(:integer) }
  it { is_expected.to have_db_column(:amount_type_id).of_type(:integer) }
  it { is_expected.to have_db_column(:price).of_type(:integer) }
  it { is_expected.to have_db_column(:amount).of_type(:float) }
  it { is_expected.to have_db_column(:name).of_type(:string) }

  it { expect(item).to validate_presence_of(:receipt_id) }
  it { expect(item).to validate_presence_of(:currency_id) }
  it { expect(item).to validate_presence_of(:amount_type_id) }
  it { expect(item).to validate_presence_of(:name) }
  it { expect(item).to validate_presence_of(:price) }
  it { expect(item).to validate_presence_of(:amount) }
  it { expect(item).to validate_presence_of(:name) }

  it { expect(item).to validate_numericality_of(:amount).is_greater_than(0) }
  it { expect(item).to validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
end
