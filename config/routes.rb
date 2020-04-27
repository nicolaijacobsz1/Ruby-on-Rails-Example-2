Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  post "/graphql", to: "graphql#execute"

  devise_scope :user do
    match 'upload_photo', to: 'image#update', via: [:post]
    match 'upload_attachment', to: 'attachment#update', via: [:post]

  end

  devise_for :users
  # if Rails.env.development?
  #   mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
