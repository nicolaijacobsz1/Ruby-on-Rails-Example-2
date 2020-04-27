module Types
    IssuingOrganizationType = GraphQL::ObjectType.define do
      name 'IssuingOrganizationType'
      description 'Organization'
      field :id, types.ID
      field :description, types.String
      field :name, types.String
      field :flag_none, types.Boolean
    end
  end
  