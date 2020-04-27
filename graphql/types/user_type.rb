# frozen_string_literal: true
module Types
  UserType = GraphQL::ObjectType.define do
    name 'User'
    description 'a user'
    field :id, types.ID
    field :name, types.String
    field :email, types.String
    field :role, types.String
    field :phone_number, types.String
    field :about, types.String
    field :summary, types.String
    field :title, types.String
    field :location, types.String
    field :areas_of_interest, types[types.String]
    field :industries, types[types.String]
    field :categories, types[types.String]
    field :token, types.String do
      resolve(lambda do |user, _args, ctx|    
        if ctx[:token].present?
          ctx[:token]
        else
          GenerateToken.new(user).generate
        end
      end)
    end

    field :profile_image_url, types.String do 
      resolve(lambda do |user, _args, ctx|
        if user.profile_image
          Refile.attachment_url(user, :profile_image, :fill, 200, 200)
        end
      end)
    end   
    
    field :posts, types[Types::PostType] do 
      resolve(lambda do |user, _args, ctx|
        if user.coach?
          coach = Coach.find(user.id)
          coach.posts.where(flag_active: true)
        end
      end)
    end
    
    field :qualifications, types[Types::QualificationType] do 
      resolve(lambda do |user, _args, ctx|
        (user.qualifications if user.qualifications.present?)
      end)
    end

    field :classifications, types[Types::CoachingType] do 
      resolve(lambda do |user, _args, ctx|
        user.coaching_types if user.coaching_types.present?
      end)
    end  

    field :testimonials, types[Types::TestimonialType] do 
      resolve(lambda do |user, _args, ctx|
        if user.coach?
          coach = Coach.find(user.id)
          coach_testimonials = coach.testimonials.where(flag_active: true)
          service_testimonials = []
          coach.services.each do |service|
            service.testimonials.each do |testimonial|
              service_testimonials.push(testimonial)
            end
          end
          coach_testimonials + service_testimonials
        end
      end)
    end 

    field :public_services, types[Types::ServiceType] do 
      resolve(lambda do |user, _args, ctx|
        if user.coach?
          coach = Coach.find(user.id)
          coach.services.where(flag_active: true, status: 'public')
        end
      end)
    end 

    field :services, types[Types::ServiceType] do 
      resolve(lambda do |user, _args, ctx|
        if user.coach?
          coach = Coach.find(user.id)
          coach.services.where(flag_active: true)
        end
      end)
    end 
    
    field :average_ratings, types.Int do 
      resolve(lambda do |user, _args, ctx|
        if user.coach?
          coach = Coach.find(user.id)
          coach.average_ratings
        end
      end)
    end 

    field :notifications, types[Types::NotificationType] do 
      resolve(lambda do |user, _args, ctx|
        user.notifications.where(flag_read: false).last(30).reverse if user.notifications.present?
      end)
    end  
    field :followers, types[Types::UserType] do 
      resolve(lambda do |user, _args, ctx|
          user.followers
      end)
    end

     field :followings, types[Types::UserType] do 
       resolve(lambda do |user, _args, ctx|
        # followings field is to get user's following list / list of people that one user followed
        # check whether user has follower_requests relation and the relation is present or not
        # if the relation is exist and present, get following_ids from follower_requests table by plucking only following_id 
        # from the plucked following_ids, get followings by finding using User model 
        # Find followings using user model based on id ( User.find(id)). The value of id is passed from following_ids
         if user.follower_requests.present?
          # Need to check whether the follower and following are approved or notz
            if user.follower_requests.where(aasm_state: 'approved').present?
             # Plucking only following id(s) from follower requests    
             # The plucked following_ids will be stored into variable ids as in line 109
             # .distinct.pluck(:<column_name>) is used to select column with unique and distinct value 
              ids = user.follower_requests.distinct.pluck(:following_id)
              # Find array of users using variable ids (plucked following ids) as in line above 
               User.find(ids)
             end
         end
       end)
     end

  end
end
