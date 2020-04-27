module Inputs
    QualificationInput = GraphQL::InputObjectType.define do
      name 'QualificationInput'
      argument :organization_id, !types.ID
      argument :date_issued, types.String
      argument :certification_awarded, !types.String
      argument :credential_id, types.String
      argument :organization_name, types.String

    end
  end