require 'rails_helper'

RSpec.describe ItemUser, type: :model do
  let(:item_user) { create :item_user }

  it { is_expected.to have_db_column(:item_id).of_type(:integer) }
  it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  it { is_expected.to have_db_column(:status).of_type(:integer) }

  it { expect(item_user).to validate_presence_of(:item_id) }
  it { expect(item_user).to validate_presence_of(:user_id) }
  it { expect(item_user).to validate_presence_of(:status) }

  it do
    expect(item_user).to validate_uniqueness_of(:user_id)
      .scoped_to(:item_id)
  end

  it do
    expect(item_user).to validate_uniqueness_of(:item_id)
      .scoped_to(:user_id)
  end

  it { expect(create :item_user, status: ItemUser.statuses.keys.sample).to be_valid }
  it { expect { create :item_user, status: 'wrong status' }.to raise_error(ArgumentError) }
end
