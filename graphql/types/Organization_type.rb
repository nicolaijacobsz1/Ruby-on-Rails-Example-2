module Types
    OrganizationType = GraphQL::ObjectType.define do
      name 'OrganizationType'
      description 'Organization'
      field :id, types.ID
      field :description, types.String
      field :name, types.String
    end
  end
  