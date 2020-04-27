Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :test_hello_world, types.String do
    # argument :user_id, types.Int
    resolve(lambda do |_obj, _args, _ctx|
      "Hello World!"
    end)
  end

  field :check_user_role, types.String do
    # argument :user_id, types.Int
    resolve(lambda do |_obj, _args, ctx|
      user = ctx[:current_user]
      user.coach?
    end)
  end

    ###TESTIMONIALS
    field :testimonial, Types::TestimonialType do
      argument :testimonial_id, types.Int
      resolve(lambda do |_obj, _args, _ctx|
        Testimonial.find(args[:testimonial_id])
      end)
    end

    ###SERVICES
    field :services, types[Types::ServiceType] do
      resolve(lambda do |_obj, _args, _ctx|
        Service.where(flag_active: true, status: 'public')
      end)
    end

    ###POST
    field :post, Types::PostType do
      argument :post_id, types.Int
      resolve(lambda do |_obj, _args, _ctx|
        Post.find(args[:post_id])
      end)
    end

    field :posts, types[Types::PostType] do
      resolve(lambda do |_obj, _args, _ctx|
        Post.all
      end)
    end

    field :posts_from_coach, types[Types::PostType] do
      resolve(lambda do |_obj, _args, ctx|
        user = ctx[:current_user]
          if user.coach?
            coach = Coach.find(user.id)
            posts = coach.posts.where(flag_active: true)
          else
            GraphQL::ExecutionError.new "User is not a coach!"
          end 
      end)
    end

    ### PROFILE AND USER
    field :current_user, Types::UserType do
    resolve(lambda do |_obj, _args, ctx|
        user = ctx[:current_user]
        if user
          User.find(user.id)
        else
          GraphQL::ExecutionError.new "User not found!"
        end 
      end)
    end
    
    field :profile, Types::UserType do
      argument :user_id, types.Int
      resolve(lambda do |_obj, args, _ctx|
        User.find(args[:user_id])
      end)
    end

    field :new_users, types[Types::UserType] do
      argument :user_id, types.Int
      resolve(lambda do |_obj, _args, _ctx|
        User.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
      end)
    end

  #COACH TYPE
  field :coach, Types::CoachType do
    resolve(lambda do |_obj, _args, ctx|
       user = ctx[:current_user]
       if user.role == 'coach'
          coach = Coach.find(user.id)
       else
         GraphQL::ExecutionError.new "Coach not found!"
       end 
     end)
   end
  field :user_devices, types[Types::DeviceType] do
    resolve(lambda do |_obj, _args, _ctx|
      UserDevice.all
    end)
  end
    
    field :profile, Types::UserType do
      argument :user_id, types.Int
      resolve(lambda do |_obj, args, _ctx|
        User.find(args[:user_id])
      end)
    end
    # COMMENTS
    field :comments, types[Types::CommentType] do
      argument :post_id, types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### QUERY: FIND ARRAY OF COMMENTS"
        # get post with post_id from argument post_id
        # get all comments associated to the post
        post = Post.find(args[:post_id])
        comments = post.comments
      end)
    end
    # Get a specific comment by finding using argument comment_id 
    # Return type should be one single object CommentType 
    field :comment, Types::CommentType do
      argument :comment_id, types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### QUERY: FIND A COMMENT"
        comment = Comment.find(args[:comment_id])
      end)
    end

  ###FOLLOWERS
  field :followers, Types::UserType do
    argument :follower_ids, types.Int
    resolve(lambda do |_obj, _args, _ctx|
      User.find(args[:follower_ids])
    end)
  end 
###SPECIALIZATION
    field :specializations, types[Types::SpecializationType] do
      resolve(lambda do |_obj, _args, _ctx|
        Specialization.where(flag_active: true)
      end)
    end

###ORGANIZATION 
field :organizations, types[Types::IssuingOrganizationType] do
  resolve(lambda do |_obj, _args, _ctx|
    Organization.where(flag_active: true)
  end)
 end

   ###FOLLOWER POST
  field :discovery_post, types[Types::PostType] do
    resolve(lambda do |obj, _args, ctx|
      user = ctx[:current_user]
      public_posts = Post.where(flag_draft: false, flag_active: true, flag_private: false)
      posts_from_coach = []

      if user.follower_requests.present?
        if user.follower_requests.where(aasm_state: 'approved').present?
          ids = user.follower_requests.distinct.pluck(:following_id)
          posts_from_coach = Post.where(flag_draft: false, flag_active: true, flag_private: true, coach_id: ids)
        end
      else
        GraphQL::ExecutionError.new "No following found"
      end
      public_posts + posts_from_coach
      
    end)
 end
      ###LIST OF SUBSCRIPTIONS
      field :subscription_list, types[Types::SubscriptionType] do
       resolve(lambda do |_obj, _args, ctx|
        SubscriptionPlan.all
       end)
      end  

     ##COACH TYPES
     field :coaching_types, types[Types::CoachingType] do
      resolve(lambda do |_obj, _args, ctx |
        CoachingType.where(flag_active: true)
        CoachingType.order('id')
      end)
    end
     ## CATEGORIES 
    
    #  field :keyword_posts, types[Types::PostType] do
    #   resolve(lambda do |obj, _args, ctx|
    #     user = ctx[:current_user]
    #     public_posts = Post.where(flag_draft: false, flag_active: true, flag_private: false)
    #     posts_from_categories = []
    #     if user
    #       post = public_posts
    #     categories = user.categories.distinct.pluck(:categories)
    #     posts_from_coaches = Post.where(flag_draft: false, flag_active: true, flag_private: true, categories: categories)
    
    #     else
    #       GraphQL::ExecutionError.new "No post found with keywords"
    #      end
    #      public_posts + posts_from_coaches
    #   end)
    # end
end


        