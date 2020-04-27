# frozen_string_literal: true
module Api::Errors::ActiveRecord
  extend ActiveSupport::Concern
  extend Api::Errors::Base

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_error
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid_error
  end

  private

  def record_not_found(error)
    render json: build_error(404, error), status: :not_found
  end

  def record_invalid_error(error)
    render json: build_error(422, error), status: :unprocessable_entity
  end
end
