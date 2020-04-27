# require 'net/http'
# require 'uri'
require 'httparty'
class InitializeSocialRegister
    def initialize(token)
      @token = token
    end
  
    def register
        # Get response object from both urls 
        # Linkedin doesnot provide email information inside 'Profile' API 
        # Need to call their another API - emailAddress to fetch email only 
        # Use HTTParty to fetch response from endpoints
        profile = 'https://api.linkedin.com/v2/me'
        email   = 'https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))'
        # TODO - Remove hardcoded string value 
        # Retrieve from config table instead
        header = {
          'Host': 'api.linkedin.com',
          'Connection': 'Keep-Alive',
          'Authorization': "Bearer #{@token}" #TODO - Removed hardcoded api-token
        }
        response_profile = HTTParty.get(profile, headers: header)
        response_email = HTTParty.get(email, headers: header)

        parsed_email   = JSON.parse(response_email.body)
        parsed_profile = JSON.parse(response_profile.body)

        new_email      = parsed_email['elements'].first.first.last['emailAddress'] if parsed_email['elements'].first.first.last['emailAddress'].present?
        new_first_name = parsed_profile['localizedFirstName'] if parsed_profile['localizedFirstName']
        new_last_name  = parsed_profile['localizedLastName'] if parsed_profile['localizedLastName']
        new_id         = parsed_profile['id'] if parsed_profile['id']

        user_params = {
            uuid: new_id,
            name: "#{new_first_name} #{new_last_name}",
            email: new_email
        }

        parsed_profile
        @user = User.find_for_oauth(user_params)
        @user

    end

  end