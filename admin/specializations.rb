ActiveAdmin.register Specialization do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :search_keyword, :flag_active
  #
  # or
  #
  permit_params do
    permitted = [:name, :description, :search_keyword, :flag_active]
    permitted << :other if params[:action] == 'create' && current_admin_user
    permitted
  end
  
end
