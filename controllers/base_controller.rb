class BaseController < ActionController::API
    include ActionController::ImplicitRender
    include Api::Authentication
  
    respond_to :json
end
