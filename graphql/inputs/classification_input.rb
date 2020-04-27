module Inputs
    ClassificationInput = GraphQL::InputObjectType.define do
      name 'ClassificationInput'
      argument :classification_id, types.ID
    end
  end