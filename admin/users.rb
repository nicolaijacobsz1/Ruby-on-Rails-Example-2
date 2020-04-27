ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :name, :role, :industries, :profile_image, :qualifications #:categories

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :role
    column "image" do |user|
      image_tag user.profile_image_url if user.profile_image_url
    end
    # column :current_sign_in_at
    # column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :role
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :name
      f.inputs "Attachment", :multipart => true do 
        f.input :profile_image, :as => :file, :hint => f.object.profile_image_url.present? \
          ? image_tag(f.object.profile_image_url)
          : content_tag(:span, "no cover page yet")
        #f.input :cover_page_cache, :as => :hidden 
      end
      f.input :role
      f.input :industries

      # f.input :password
      # f.input :password_confirmation
    end
    f.actions
  end

end
