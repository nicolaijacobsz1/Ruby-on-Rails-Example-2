class MessagesController < InheritedResources::Base

  private

    def message_params
      params.require(:message).permit(:subject, :body)
    end

end
