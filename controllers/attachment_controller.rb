class AttachmentController < BaseController
    before_action :authenticate_user_from_token!, :ensure_params_exist, only: [:update]

    def create
    end
  
    def update
      user = current_user
      if user
        coach = Coach.find(user.id)

        attachment = Refile.store.upload(attachment_params[:file])
        attachmentable = if attachment_params[:attachmentable_type] == 'Post'
                            coach.posts.find(attachment_params[:attachmentable_id])
                         elsif attachment_params[:attachmentable_type] == 'Service'
                            Service.find(attachment_params[:attachmentable_id])
                         end
        if attachment.id.present?
          #attachmentable.attachment.new(image_id: attachment.id)
          attach =  Attachment.new(image_id: attachment.id, attachmentable_id: attachmentable.id, attachmentable_type: attachmentable.class.to_s)
          if attach.save
            render json: { message: 'You have successfully uploaded your profile photo!', img_url: Refile.attachment_url(attach, :image)}
          else
            render json: { message: "Upload photo failed! #{attach.errors.full_messages.join(' ,')}" , img_url: nil }
          end
        end
      else
        render_unauthorized errors: { unauthenticated: ['You are not authorized to perform this action!'] }
      end
    end

    def destroy
    end
  
    private
    # Use callbacks to share common setup or constraints between actions.
    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:file, :attachmentable_id, :attachmentable_type)
    end
  
    def render_params_not_exist(payload = { errors: { params_not_exist: ['Missing parameter'] } })
      render json: payload.merge(response: { code: 422 }), status: 422
    end
  
    def ensure_params_exist
      render_params_not_exist errors: { params_not_exist: ['Missing parameter'] } if params[:attachment].blank?
    end
end
