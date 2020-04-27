# frozen_string_literal: true
module Api::Authentication
  extend ActiveSupport::Concern

  included do
    private

    def current_user
      if token_from_request.blank?
        nil
      else
        authenticate_user_from_token!
      end
    end

    alias_method :devise_current_user, :current_user

    def user_signed_in?
      !current_user.nil?
    end

    alias_method :devise_user_signed_in?, :user_signed_in?

    def authenticate_user_from_token!
      return nil if claims.nil?
      
      @current_user = User.find_by(email: claims[0]['email']) || Coach.find_by(email: claims[0]['email']) 
    end

    def claims
      return nil if token_from_request.nil?
      # Rails.logger.info " +++++++  #{JWT.decode(token_from_request, ENV['SECRET_KEY_BASE'], true)}"
      JWT.decode(token_from_request, Rails.application.secrets.secret_key_base, true)

    rescue JWT::ExpiredSignature => e
      raise Api::ErrorsJWT::TokenExpired, e.message
    rescue JWT::DecodeError
    end

    def jwt_token(_user)
      # 10 years
      expires = Time.now.to_i + (3600 * 24 * 365 * 10)

      JWT.encode({ email: @user.email, exp: expires }, Rails.application.secrets.secret_key_base, 'HS256')
    end

    def render_unauthorized(payload = { errors: { unauthorized: ['You are not authorized to perform this action'] } })
      render json: payload.merge(response: { code: 401 }), status: 401
    end

    def token_from_request
      token = request.headers['authorization'].split(' ').last if request.headers['authorization']
      session[:token] = token
      if token.to_s.empty?
        request.parameters['token']
      else
        token
      end
    end
  end
end
