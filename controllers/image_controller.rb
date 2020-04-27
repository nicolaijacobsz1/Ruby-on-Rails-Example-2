class ImageController < BaseController
    before_action :authenticate_user_from_token!, :ensure_params_exist, only: [:update]

    def create
    end
  
    def update
      user = current_user
      if user
        image = Refile.store.upload(photo_params[:profile_image])
        if image.id.present?
          user.update(profile_image_id: image.id)
        end
        if user.save
          render json: { message: 'You have successfully uploaded your profile photo!', img_url: Refile.attachment_url(user, :profile_image, :fill, 200, 200)}
        else
          render json: { message: 'Upload photo failed!', img_url: nil }
        end
      else
        render_unauthorized errors: { unauthenticated: ['You are not authorized to perform this action!'] }
      end
    end
  
    # DELETE /photos/1
    # DELETE /photos/1.json
    def destroy
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:profile_image)
    end
  
    def render_params_not_exist(payload = { errors: { params_not_exist: ['Missing parameter'] } })
      render json: payload.merge(response: { code: 422 }), status: 422
    end
  
    def ensure_params_exist
      render_params_not_exist errors: { params_not_exist: ['Missing parameter'] } if params[:photo].blank?
    end
end
