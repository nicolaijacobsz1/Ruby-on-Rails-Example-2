class SocialProfile < ApplicationRecord
    belongs_to :user

    validates_presence_of :uuid, :platform
    validates_uniqueness_of :uuid, scope: :platform
  
  
    def self.find_for_oauth(data)
      find_or_create_by(uuid: data[:uuid], platform: 'linkedin')
    end
  
    def self.find_for_oauth_custom_email(auth)
      find_or_create_by(uuid: auth[:uuid], platform: auth['platform'])
    end
end
