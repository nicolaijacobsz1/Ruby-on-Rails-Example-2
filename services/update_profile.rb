class UpdateProfile
    def initialize(user, qualification_params, classification_params, industry_params)
        @user = user
        @qualification  = qualification_params || []
        @classification = classification_params || []
        @industry       = industry_params || []

    end

    def call
        set_industries
        set_classification
        set_qualification
        @user.qualifications.create(@qualifications) if @qualifications
        # Rails.logger.info " IDS are #{@classification_ids.class}"
        # @user.industries.push(@industry_ids) if @industry_ids.present?
        # @user.coaching_type_ids.push(@classification_ids) if @classification_ids.present?
    end

    def set_industries
        Rails.logger.info " ######## #{@industry.present?}"
        if @industry.present?
            @industry.each do |ind|
                Rails.logger.info " ######## INDUSTRY ID #{ind[:industry_id]}"
                @user.industries.push(ind[:industry_id])
            end
        end
    end

    def set_classification
        if @classification.present?
            @classification.each do |new_class|
                @user.coaching_type_ids.push(new_class[:classification_id])
            end
        end
    end

    def set_qualification
        @qualifications = []
        if @qualification.present?
         @qualification.each do |input|
         qualification_params =  
          {
            organization_id: input[:organization_id],
            credential_id: input[:credential_id],
            certification_awarded: input[:certification_awarded],
            organization_name: input[:organization_name],
          }
          @qualifications.push(qualification_params)
         end
        end
    end
end