module Types
    QualificationType = GraphQL::ObjectType.define do
      name 'QualificationType'
      description 'object to return information user qualification'
      field :id, types.ID
      field :credential_id, types.String
      field :date_issued, types.String
      field :certification_awarded, types.String
      field :organization_name, types.String do 
        resolve(lambda do |obj, _args, _ctx|
          if obj.organization_name.present? && obj.organization.flag_none
            (obj.organization_name)
          else
            obj.organization.name
          end
        end)
      end
     
    end
  end