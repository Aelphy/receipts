require 'rails_helper'

RSpec.describe ReceiptImage, type: :model do
  let(:receipt_image) { create :receipt_image }

  it { is_expected.to have_db_column(:reference_id).of_type(:integer) }

  it { expect(receipt_image).to have_attached_file(:photo) }
  it { expect(receipt_image).to validate_attachment_presence(:photo) }

  it 'validates content type' do
    expect(receipt_image).to validate_attachment_content_type(:photo)
      .allowing('image/png', 'image/jpeg', 'image/jpg')
      .rejecting('text/plain')
  end
end
