module Inputs
    CategoriesInput = GraphQL::InputObjectType.define do
      name 'CategoriesInput'
      argument :categories, types.String
    end
  end