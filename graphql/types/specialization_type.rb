module Types
    SpecializationType = GraphQL::ObjectType.define do
      name 'specialization'
      description 'a specialization'
      field :id, types.ID
      field :name, types.String
      field :description, types.String
      field :flag_active, types.Boolean
      field :search_keyword, types.String
    end
  end