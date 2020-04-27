module Inputs
    IndustryInput = GraphQL::InputObjectType.define do
      name 'IndustryInput'
      argument :industry_id, types.ID
    end
  end