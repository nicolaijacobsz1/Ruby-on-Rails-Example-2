module Types
    QuestionType = GraphQL::ObjectType.define do
      name 'Question'
      description 'a Question'
      field :id, types.ID
      field :title, types.String
      field :body, types.String
      field :attachment, types.String
      #field :coach, Types::CoachType
      field :flag_active, types.Boolean
      #field :flag_draft, types.Boolean
      field :coach_id, types.ID
      field :user_id, types.ID
    end
  end
  