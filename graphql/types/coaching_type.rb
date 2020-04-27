module Types
    CoachingType = GraphQL::ObjectType.define do
      name 'Coaching'
      description 'a Coaching'
      field :id, types.ID
      field :name, types.String
      field :description, types.String
      field :flag_active, types.Boolean
      field :recommended_for, types.String
      field :recommended_examples, types.String 
    end
end 