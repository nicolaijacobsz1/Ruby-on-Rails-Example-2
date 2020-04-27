class CreateQualifications < ActiveRecord::Migration[5.2]
  def change
    create_table :qualifications do |t|
      t.belongs_to :user
      t.belongs_to :organization
      t.string :credential_id
      t.string :date_issued
      t.string :certification_awarded
      t.boolean :flag_active, default: true
      t.timestamps
    end
  end
end
