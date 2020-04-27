module Types
    SubscriptionType = GraphQL::ObjectType.define do
      name 'subscription'
      description 'a subscription'
      field :id, types.ID
      field :name, types.String
      field :description, types.String
      field :price_cent, types.Int
      field :price_currency, types.String
      field :flag_active, types.Boolean
    end
  end