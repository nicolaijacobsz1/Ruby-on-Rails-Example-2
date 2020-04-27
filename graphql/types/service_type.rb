# frozen_string_literal: true
module Types
  ServiceType = GraphQL::ObjectType.define do
    name 'ServiceType'
    description 'Service GraphQL Object based Service model'
    field :id, types.ID
    field :body, types.String
    field :title, types.String
    field :flag_active, types.Boolean
    field :service_price, types.Float
    field :service_price_currency, types.String
    field :testimonials, types[Types::TestimonialType] do 
      resolve(lambda do |obj, _args, ctx|
        obj.testimonials

      end)
    end   

  end
end
