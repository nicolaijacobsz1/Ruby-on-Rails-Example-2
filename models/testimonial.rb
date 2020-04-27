class Testimonial < ApplicationRecord
    belongs_to :user
    belongs_to :testimonialable, polymorphic: true

end
