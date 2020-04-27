class Qualification < ApplicationRecord
    belongs_to :user
    
    def organization
        Organization.find(organization_id)
    end
end
