# frozen_string_literal: true
module Types
  PostType = GraphQL::ObjectType.define do
    name 'Post'
    description 'a Post'
    field :id, types.ID
    field :title, types.String
    field :body, types.String
    field :attachment, types.String
    field :coach, Types::CoachType
    field :flag_active, types.Boolean
    field :flag_draft, types.Boolean
    field :coach_id, types.ID
    field :likes, types.Int
    field :comments, types[Types::CommentType]
    field :share_link, types.String do 
      resolve(lambda do |obj, _args, _ctx|
          url = ENV['APP_URL']
          (url + "/post/#{obj.id}")
      end)
    end 
    field :attachment_url, types.String do 
      resolve(lambda do |obj, _args, _ctx|
        if obj.attachment
          Refile.attachment_url(obj.attachment, :image)
        end
      end)
    end 

    field :total_comments, types.Int do 
      resolve(lambda do |obj, _args, ctx|
          (obj.total_comments)
      end)
    end

    field :created_at, types.String do 
      resolve(lambda do |obj, _args, ctx|
        time_ago_in_words(obj.created_at)
      end)
    end

  end
end
