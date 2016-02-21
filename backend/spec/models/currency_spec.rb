require 'rails_helper'

RSpec.describe Currency, type: :model do
  let(:currency) { create :currency }

  it { is_expected.to have_db_column(:name).of_type(:string) }
  it { is_expected.to have_db_column(:exchange_rate).of_type(:float) }

  it { expect(currency).to validate_presence_of(:name) }
  it { expect(currency).to validate_presence_of(:exchange_rate) }

  it { expect(currency).to validate_uniqueness_of(:name) }
  it { expect(currency).to validate_numericality_of(:exchange_rate).is_greater_than(0) }
end
