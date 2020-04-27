class Attachment < ApplicationRecord
    #belongs_to :attachmentable, polymorphic: true
    attachment :image
    validates_presence_of :image

end
