module Types
    CommentType = GraphQL::ObjectType.define do
    name 'Comment'
      description 'a Comment'
      field :id, types.ID
      field :body, types.String
      field :attachment, types.String
      field :user, Types::UserType
      field :post, !Types::PostType
    end
  end
  