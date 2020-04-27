class UserMailer < ApplicationMailer
    def forget_password(user_id)
        Rails.logger.info "------------ USER MAILER ---------------"

        @user = User.find(user_id)
        Rails.logger.info "User from user mailer is #{@user}"
        raw, enc = Devise.token_generator.generate(User, :reset_password_token)
        @token = raw
        @user.reset_password_token   = enc
        @user.reset_password_sent_at = Time.now.utc
        @user.save
        mail(to: @user.email, subject: 'Reset Coaciety Password')
    end
end
