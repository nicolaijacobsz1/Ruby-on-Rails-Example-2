# frozen_string_literal: true
module Types
  CoachType = GraphQL::ObjectType.define do
    name 'Coach'
    description 'a coach'
    field :id, types.ID
    field :name, types.String
    field :email, types.String
    field :token, types.String do
      resolve(lambda do |user, _args, ctx|
        ctx[:token] if ctx[:token]
        
      end)
    end
    field :role, types.String
    field :phone_number, types.String
    field :about, types.String
    field :summary, types.String
    field :profile_image_url, types.String
    field :areas_of_interest, types[types.String]
    field :posts, types[Types::PostType] do 
      resolve(lambda do |user, _args, ctx|
        if user.coach?
          coach = Coach.find(user.id)
          coach.posts.where(flag_active: true)
        end
      end)
    end   

    field :testimonials, types[Types::TestimonialType] do 
      resolve(lambda do |user, _args, ctx|
        if user.coach?
          coach = Coach.find(user.id)
          coach.testimonials.where(flag_active: true)
        end
      end)
    end 
  end
end