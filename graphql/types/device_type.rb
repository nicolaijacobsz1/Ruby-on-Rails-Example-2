module Types
    DeviceType = GraphQL::ObjectType.define do
      name 'device'
      description 'user device'
      field :id, types.ID
      field :user_id, types.ID
      field :fcm_token, types.String
    end
  end
  