Types::MutationType = GraphQL::ObjectType.define do
  name 'Mutation'
    # USER
    # MUTATION: SIGN UP
    # argument with ! is the same as required: true 
    field :sign_up, Types::UserType do
      argument :name, !types.String
      argument :phone_number, types.String
      argument :email, !types.String
      argument :password, !types.String
      argument :password_confirmation, !types.String
      argument :role, types.String
      argument :qualification, types.String
      argument :about, types.String
      argument :summary, types.String
      resolve(lambda do |_obj, args, _ctx|
        Rails.logger.info " ####### MUTATION: SIGN UP"
        # args.to_h.symbolize_keys will hash the argument keys together so easier to pass the arguments together
        params = args.to_h.symbolize_keys.except(:password_confirmation)
        if args[:password] == args[:password_confirmation]
          user = User.new(params)
          # Check whether user object can be saved into the DB or not
          if user.save
            user
          else
            GraphQL::ExecutionError.new user.errors.full_messages.join(" , ")
          end

        else
          GraphQL::ExecutionError.new "Password does not match"
        end

      end)
    end

    field :social_sign_up, Types::UserType do
      argument :access_token, types.String
      resolve(lambda do |_obj, args, _ctx|
        InitializeSocialRegister.new(args[:access_token]).register
      end)
    end

    # MUTATION: SIGN IN
    field :sign_in, Types::UserType do
      argument :email, !types.String
      argument :password, !types.String
      resolve(lambda do |_obj, args, _ctx|
        Rails.logger.info " ####### MUTATION: SIGN IN"
        user =  User.find_for_database_authentication(email: args[:email]) 
        if user
          if user.valid_password? args[:password]
             user
          else 
            GraphQL::ExecutionError.new "Invalid password"
          end
        else 
          GraphQL::ExecutionError.new "Invalid email"
        end
      end)
    end

    field :forget_password_email, types.String do
      argument :email, types.String
      resolve(lambda do |_obj, args, ctx|
        user = User.find_by(email: args[:email])
        Rails.logger.info "EMAIL is #{ENV['GMAIL_USERNAME']}"
        if user
          UserMailer.forget_password(user.id).deliver_now
          "Succesfully sent email to #{user.email}"
        else
          GraphQL::ExecutionError.new "User not found!"
        end
  
      end)
    end

    field :request_follow, Types::UserType do
      argument :user_id, !types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: REQUEST FOLLOWER"

        # Get follower object 
        # Get following object by finding from user based on argument user_id
        # Check whether if follower exist or not, 
        # If follower exist check following is exist or not. 
        # If following exist, create a new record into FollowerRequests table

        follower =  ctx[:current_user]
        following = User.find(args[:user_id])
        
        if follower
          if following
            follow_request = follower.follower_requests.new(following_id: following.id)
            if follow_request.save
              following
            else
              GraphQL::ExecutionError.new follow_request.errors.full_messages.join(" , ")
            end
          end
        else 
          GraphQL::ExecutionError.new "You are not allowed to performed this action."
        end
      end)
    end

    field :approve_request_follow, Types::UserType do
      argument :follower_id, !types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: REQUEST FOLLOWER"

        # Get requester(follower) information by finding from user table based on follower_id
        # Get current user 
        # Check whether if follower exist or not, 
        # If follower exist check following is exist or not. 
        # If current user  exist and follower exist, approve the request and insert new user_id into current_user follower_ids

        user =  ctx[:current_user]
        follower = User.find(args[:follower_id])
        
        if user
          if follower
            request_follow = FollowerRequest.find_by(follower_id: follower.id, following_id: user.id)
            if request_follow
              request_follow.aasm_state = 'approved'
              request_follow.save
              user.follower_ids.push(follower.id)
              # Create a new record into notifications table with some messages saying that follower request is approved 
              # Create a record that will tie to follower instead cause we want to inform follower that their request is approved
              # .notifications is a method from has_many :notifications 
              # column :body will contain the message notification
              notification = follower.notifications.new(notifiable_id: request_follow.id, notifiable_type: request_follow.class.to_s, title: 'Request Approved', body: "#{user.name} has accepted your follow request.")
              notification.save if notification
              user
            end           
          end
        else 
          GraphQL::ExecutionError.new "You are not allowed to performed this action."
        end
      end)
    end

    field :decline_request_follow, Types::UserType do
      argument :follower_id, !types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: Decline Request FOLLOWER"

        # Get follower object 
        # Get following object by finding from user based on argument user_id
        # Check whether if follower exist or not, 
        # If follower exist check following is exist or not. 
        # If following exist, delete request

        user =  ctx[:current_user]
        follower = User.find(args[:follower_id])
        
        if user
          if follower
            request_follow = FollowerRequest.find_by(follower_id: follower.id, following_id: user.id)
            request_follow.aasm_state = 'declined'
            request_follow.save
            user
          end
        else 
          GraphQL::ExecutionError.new "You are not allowed to performed this action."
        end
      end)
    end


    ##### USER DEVICES AND NOTIFICSTIONS
    field :create_user_device, Types::UserType do
      argument :fcm_token, !types.String
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: NOTIFICATION MUTATION"
        params = args.to_h.symbolize_keys
        user = ctx[:current_user]
        if user 
          user_device = UserDevice.new(user_id: user.id, fcm_token: args[:fcm_token])
          if user_device.save
            user_device
          else
            GraphQL::ExecutionError.new user_device.errors.full_messages.join(" , ")
          end

        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end

      end)
    end

    #READ notification 
    field :read_notification, Types::NotificationType do
      argument :notification_id, types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: READ NOTIFICATION"
        params = args.to_h.symbolize_keys
        user = ctx[:current_user]
        if user 
          notification = user.notifications.find(args[:notification_id])
          notification.update(flag_read: true) if notification
        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end
      end)
    end

    #UPDATE notification    
    field :update_notification, Types::NotificationType do
      argument :notification_id, types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: UPDATE NOTIFICATION"
        
        user = ctx[:current_user]
        notification = Notification.find(args[:notification_id])
        params = args.to_h.symbolize_keys
        params.delete(:notification_id)
        object_params = params.delete_if { |_key, value| value.blank? }

        if notifaction
          notification = user.notifications.find(args[:notification_id])
          notification.update(object_params)
           if notification.save
              notification
           else 
              GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
           end
        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end
      end)
    end

    #### TESTIMONIALS
    field :create_testimonial, Types::TestimonialType do
      argument :testimonialable_id, !types.Int
      argument :testimonialable_type, !types.String
      argument :title, !types.String
      argument :body, !types.String
      argument :ratings, !types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: CREATE TESTIMONIAL"

        user = ctx[:current_user]
        params = args.to_h.symbolize_keys
        params[:user_id] = user.id
       
        if user 
          testimonial = Testimonial.new(params)
          if testimonial.save
            testimonial
          else
            GraphQL::ExecutionError.new testimonial.errors.full_messages.join(" , ")
          end 
        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end
      end)
    end

    #### SERVICES
    field :create_service, Types::ServiceType do
      argument :title, types.String
      argument :body, types.String
      argument :service_price_cents, types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: CREATE TESTIMONIAL"
        #args[:service_price_cents] = Money.new(args[:service_price_cents]*100)
        params = args.to_h.symbolize_keys
        user = ctx[:current_user]
        if user.coach?
          coach = Coach.find(user.id)
          service = coach.services.new(params)
          if service.save
            service
          else
            GraphQL::ExecutionError.new service.errors.full_messages.join(" , ")
          end 
        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end
      end)
    end

    #### COMMENTS
    field :create_comment, Types::CommentType do
      argument :body, !types.String
      argument :attachment, types.String
      argument :post_id, types.ID
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: COMMENT"
          user = ctx[:current_user]
          comment = user.comments.new(post_id: args[:post_id], body: args[:body], attachment: args[:attachment])
           if comment.save
            comment
           else
            GraphQL::ExecutionError.new comment.errors.full_messages.join(" , ")
          end 
     end)
    end

    ##### POSTS
    # argument with ! is the same as required: true 
    field :create_post, Types::PostType do
      argument :title, !types.String
      argument :body, !types.String
      argument :attachment, types.String
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: POST"

        params = args.to_h.symbolize_keys
        user = ctx[:current_user]
        Rails.logger.info " User id is #{user.id}"
        Rails.logger.info " User role is #{user.role}"
        if user.role == 'coach'
          coach = Coach.find(user.id)
          post = coach.posts.new(title: args[:title], body: args[:body], attachment: args[:attachment])
          if post.save
            post
          else
            GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
          end 
        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end
     end)
  end

  field :coach_delete_post, Types::PostType do
    argument :post_id, !types.Int
    resolve(lambda do |_obj, args, ctx|
      Rails.logger.info " ####### MUTATION: DELETE POST"

      user = ctx[:current_user]
      if user.coach?
        coach = Coach.find(user.id)
        post = coach.posts.find(args[:post_id])
        post.flag_active = false
        if post.save
          post
        else
          GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
        end
      else
        GraphQL::ExecutionError.new "You are not allowed to perform this action."
      end
    end)
  end

  field :coach_update_post, Types::PostType do
    argument :post_id, !types.Int
    argument :body, types.String
    argument :title, types.String
    argument :flag_active, types.Boolean, default_value: true

    resolve(lambda do |_obj, args, ctx|
      Rails.logger.info " ####### MUTATION: UPDATE POST"

      user = ctx[:current_user]
      params = args.to_h.symbolize_keys
      params.delete(:post_id)
      object_params = params.delete_if { |_key, value| value.blank? } # This line will delete any keys in 'params' that has null value

      if user.coach?
        coach = Coach.find(user.id)
        post  = coach.posts.find(args[:post_id])
        post.update(object_params)
        if post.save
          post
        else
          GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
        end
      else
        GraphQL::ExecutionError.new "You are not allowed to perform this action."
      end
    end)
  end

  #MUTATION:SHOW DRAFT POST
  field :coach_show_draft_post, Types::PostType do
    argument :post_id, !types.Int
    resolve(lambda do |_obj, args, ctx|
      Rails.logger.info " ####### MUTATION: DRAFT POST"

      user = ctx[:current_user]
      if user.coach?
        coach = Coach.find(user.id)
        post = coach.posts.find(args[:post_id])
        post.flag_draft = true
        if post.save
          post
        else
          GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
        end
      else
        GraphQL::ExecutionError.new "You are not allowed to perform this action."
      end
    end)
  end

  # MUTATION: CREATE Comment
    # argument with ! is the same as required: true 
    field :create_comment, Types::CommentType do
      argument :body, !types.String
      argument :attachment, types.String
      argument :post_id, types.ID
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: COMMENT"
        # Get current user (commenter)
        # Get post based on argument post_id
        # Check whether post exist or not
        # If exist allow user to create comment
        # If not, throw error message 

          user = ctx[:current_user]
          post = Post.find(args[:post_id])
           if post.present?
             comment = user.comments.new(post_id: args[:post_id], body: args[:body], attachment: args[:attachment])
            if comment.save
              comment
            else 
              GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
            end
          else 
            GraphQL::ExecutionError.new "Post does not exist."
          end
     end)
    end

    #MUTATION: DELETE Comment  
    field :delete_comment, Types::CommentType do
      argument :comment_id, !types.Int
      argument :post_id, !types.ID
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION:DELETE COMMENT"
        # Get current user (commenter)
        # Get comment based on argument comment_id
        # Check whether comment exist or not
        # If exist allow user to delete comment
        # If not, throw error message 

          user = ctx[:current_user]
          post = Post.find(args[:post_id])
          if post.present?
            comment = user.comments.find_by(post_id: args[:post_id], id: args[:comment_id])
            comment.flag_active = false
            if comment.save
              comment
            else
              GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
            end
          else
            GraphQL::ExecutionError.new "Comment not found."
          end
    end)
  end
  #MUTATION: UPDATE Comment
  field :update_comment, Types::CommentType do
    argument :comment_id, types.ID
    argument :body, !types.String
    argument :attachment, types.String

    resolve(lambda do |_obj, args, ctx|
      Rails.logger.info " ####### MUTATION: UPDATE Comment"

      user = ctx[:current_user]
      comment = Comment.find(args[:comment_id])
      params = args.to_h.symbolize_keys
      params.delete(:comment_id)
      object_params = params.delete_if { |_key, value| value.blank? } # This line will delete any keys in 'params' that has null value

      if comment
        comment.update(object_params)
       if comment.save
         comment
       else 
         GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
       end
     else 
       GraphQL::ExecutionError.new "comment doesnt exist."
     end

    end)
  end
# MUTATION: ADD Saved Item
  field :add_saved_item, Types::PostType do
    argument :post_id, !types.ID
    resolve(lambda do |_obj, args, ctx |
       user = ctx [:current_user]
       post = Post.find(args[:post_id])
       if post.present?
        saved_item = user.saved_items.new(post_id: args[:post_id])
        if saved_item.save
           saved_item
        else
          GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
        end
      else
        GraphQL::ExecutionError.new "Post not found."
      end
    end)
  end  

  #MUTATION: DELETE SavedItem
field :delete_saved_item, Types::PostType do
  argument :post_id, !types.ID
  argument :saved_item_id, !types.ID
  resolve(lambda do |_obj, args, ctx|
    Rails.logger.info " ####### MUTATION:DELETE COMMENT"
    # Get current user
    # Get post based on argument post_id
    # Check whether post exist or not
    # If exist allow user to delete post from saved items
    # If not, throw error message 

      user = ctx[:current_user]
      post = Post.find(args[:post_id])
       if post.present?
         saved_item = user.saved_items.find_by(post_id: args[:post_id], id: args[:saved_item_id])
         saved_item.flag_active = false
         if saved_item.save
            saved_item
         else
           GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
         end
       else
         GraphQL::ExecutionError.new "Saved_item not found."
       end
 end)
end
  #MUTATION: DELETE Follower  
field :delete_follower, Types::UserType do
  argument :follower_id, !types.Int
  resolve(lambda do |_obj, args, ctx|
    Rails.logger.info " ####### MUTATION:DELETE FOLLOWER"
    # Get current user
    # Get follower by using users table
    # Find the follower by filtering users using follower_id
    # Check whether follower exist or not
    # If exist allow user to remove from followers list
    # If not, throw error message 

      user = ctx[:current_user]
      follower = User.find(args[:follower_id])
      
       if user.present? && follower.present?
        Rails.logger.info " ###### User follower ids : #{user.follower_ids}"
        User.connection.execute("UPDATE USERS SET FOLLOWER_IDS = array_remove(FOLLOWER_IDS, '#{follower.id}') WHERE ID=#{user.id};")

        # Remove follower id from column follower_ids inside users table
         if user.save
            user
         else 
          GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
         end
       else
         GraphQL::ExecutionError.new "follower not found."
       end
    end)
  end

  ##MUTATION: UPDATE PROFILE
  field :update_profile, Types::UserType do
    argument :name, types.String
    argument :role, types.String
    argument :qualification, types[Inputs::QualificationInput]
    argument :classification_ids, types[Inputs::ClassificationInput]
    argument :about, types.String
    argument :summary, types.String
    argument :industries, types[Inputs::IndustryInput]
    argument :title, types.String
    argument :location, types.String
    argument :role, types.String
    resolve(lambda do |_obj, args, ctx|
      Rails.logger.info " ####### MUTATION:UPDATE PROFILE"
      user = ctx[:current_user]
      params = args.to_h.symbolize_keys.except(:qualification, :classification_ids, :industries)
      object_params = params.delete_if { |_key, value| value.blank? }
        if user.present?
          UpdateProfile.new(user, args[:qualification],args[:classification_ids], args[:industries]).call
          user.update(object_params)
          if user.save
            user
          else
            GraphQL::ExecutionError.new user.errors.full_messages.join(' , ')
          end
        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end
    end)
  end

    ##### Questions
    field :create_questions, Types::QuestionType do
      argument :title, !types.String
      argument :body, !types.String
      argument :attachment, types.String
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION: Question"

        params = args.to_h.symbolize_keys
        user = ctx[:current_user]
        Rails.logger.info " User id is #{user.id}"
        if user
          user = User.find(user.id)
          question = user.questions.new(title: args[:title], body: args[:body], attachment: args[:attachment])
          if question.save
            question
          else
            GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
          end 
        else
          GraphQL::ExecutionError.new "You are not allowed to perform this action."
        end
     end)
    end
  
  field :delete_question, Types::QuestionType do
    argument :question_id, !types.Int
    resolve(lambda do |_obj, args, ctx|
      Rails.logger.info " ####### MUTATION: DELETE QUESTION"

      user = ctx[:current_user]
      if user
        user = User.find(user.id)
        question = user.questions.find(args[:question_id])
        question.flag_active = false
        if question.save
          question
        else
          GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
        end
      else
        GraphQL::ExecutionError.new "You are not allowed to perform this action."
      end
    end)
  end

  #### LIKES
    field :like_post, Types::PostType do
      argument :post_id, !types.Int
      resolve (lambda do |_obj, args, ctx|
        Rails.logger.info "##### MUTATION: LIKE POST"
        post = Post.find(args[:post_id])
        user = ctx [:current_user]
        
        if post.present?
          notification = user.notifications.new(notifiable_id: post.id, notifiable_type: post.class.to_s, title: 'Post Recieved a Like', body: "#{user.name} has liked your post")
          if notification.save
            notification
          end
          post
        end
      end)
     end

    field :unlike_post, Types::PostType do
      argument :post_id, !types.Int
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info "#####MUTATION: UNLIKE POST"
          post = Post.find(args[:post_id])
          if post.present?
            post.decrement!(:likes)
          end
          post
        end)
      end

    ##Categories 
    field :add_categories, Types::UserType do
      argument :categories, !types[Inputs::CategoriesInput]
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION:CREATE CATEGORIES"
        user = ctx[:current_user]
         if user.present?
            args[:categories].each do |input|
            user.categories.push(input[:categories])
            end
            user.save
           user
         else
            GraphQL::ExecutionError.new "user not found."
         end  
      end)
    end
    field :delete_categories, Types::UserType do
      argument :categories, !types.String
      resolve(lambda do |_obj, args, ctx|
        Rails.logger.info " ####### MUTATION:DELETE CATEGORIES"
          user = ctx[:current_user]
          categories = (args[:categories])
           if user.present?
            User.connection.execute("UPDATE USERS SET CATEGORIES = array_remove(categories,'#{categories}');")
             if user.save
                user
             else 
              GraphQL::ExecutionError.new post.errors.full_messages.join(" , ")
             end
           else
             GraphQL::ExecutionError.new "User not found."
           end
        end)
      end
### END OF Mutation Type Definition
end