ActiveAdmin.register Notification do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :notifiable_id, :notifiable_type, :title, :body, :flag_read
  # #
  # # or
  # #
  # permit_params do
  #   permitted = [:user_id, :notifiable_id, :notifiable_type, :title, :body, :flag_read]
  #   permitted << :other if params[:action] == 'create' && current_admin_user
  #   permitted
  # end

  index do
    selectable_column
    id_column
    column :id
    column :notifiable_id
    column :notifiable_type
    column :title
    column :body
    actions
  end

  filter :notifiable_type
  filter :body
  filter :title
  filter :created_at

  form do |f|
    f.inputs do
      f.input :notifiable_type
      f.input :notifiable_id
      f.input :body
    end
    f.actions
  end

  
end
