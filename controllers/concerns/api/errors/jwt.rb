# frozen_string_literal: true
module Api::Errors::JWT
  extend ActiveSupport::Concern
  extend Api::Errors::Base

  class TokenUnauthorized < StandardError; end
  class TokenMissing < StandardError; end
  class TokenInvalid < StandardError; end
  class TokenExpired < StandardError; end
  class TokenNotDecoded < StandardError; end

  included do
    rescue_from API::Errors::JWT::TokenUnauthorized, with: :unauthorized_error
    rescue_from API::Errors::JWT::TokenMissing, with: :token_missing_error
    rescue_from API::Errors::JWT::TokenInvalid, with: :token_invalid_error
    rescue_from API::Errors::JWT::TokenExpired, with: :token_expired_error
    rescue_from API::Errors::JWT::TokenDecode, with: :token_decode_error
  end

  private

  def unauthorized_error(error)
    render json: build_error(401, error), status: :unauthorized
  end

  def token_missing_error(error)
    render json: build_error(401, error), status: :unauthorized
  end

  def token_invalid_error(error)
    render json: build_error(401, error), status: :unauthorized
  end

  def token_expired_error(error)
    render json: build_error(401, error), status: :unauthorized
  end

  def token_decode_error(error)
    render json: build_error(401, error), status: :unauthorized
  end
end
