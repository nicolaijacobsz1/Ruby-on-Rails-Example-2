# frozen_string_literal: true
module Types
  NotificationType = GraphQL::ObjectType.define do
    name 'NotificationType'
    description 'Notification GraphQL Object based Notification model'
    field :id, types.ID
    field :role, types.String
    field :body, types.String
    field :title, types.String
    field :notifiable_id, types.String
    field :notifiable_type, types.String
    field :flag_read, types.Boolean

  end
end
