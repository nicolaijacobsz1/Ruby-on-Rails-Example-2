ActiveAdmin.register Service do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :coach_id, :title, :body, :service_price_cents, :service_price_currency, :attachment_id, :status, :flag_active
  #
  # or
  #
  permit_params do
    permitted = [:coach_id, :title, :body, :service_price, :service_price_currency, :attachment_id, :status, :flag_active]
    permitted << :other if params[:action] == 'create' && current_admin_user
    permitted
  end
  
end
