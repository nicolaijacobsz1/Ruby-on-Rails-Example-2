# frozen_string_literal: true
module Types
  TestimonialType = GraphQL::ObjectType.define do
    name 'TestimonialType'
    description 'Testimonial GraphQL Object based Testimonial model'
    field :id, types.ID
    field :body, types.String
    field :title, types.String
    field :flag_active, types.Boolean
    field :ratings, types.Int
    field :user, Types::UserType

  end
end
