# frozen_string_literal: true
module Api::Errors::Base
  class << self
    private

    def build_error(exception, status, title = exception.class.to_s, message = exception.message.capitalize)
      {
        errors: [
          {
            status:  status.to_s,
            title:   ActiveSupport::Inflector.demodulize(title).titleize,
            message: message,
          }
        ],
        meta:   {
          success:     false,
          status_code: status.to_s,
        },
      }
    end
  end
end
