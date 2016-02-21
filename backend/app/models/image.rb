class Image < ActiveRecord::Base
   has_attached_file :photo, style: { big: '300x100>' }

   validates :photo, attachment_presence: true
   validates_attachment_content_type :photo,
     content_type: ['image/jpeg', 'image/jpg', 'image/png']
end
