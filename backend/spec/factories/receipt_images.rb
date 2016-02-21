include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :receipt_image do
    association :receipt
    photo do
      fixture_file_upload(File.join(Rails.root,
                                    'public',
                                    'default_picture.jpg'),
                          'image/png')
    end
  end
end
