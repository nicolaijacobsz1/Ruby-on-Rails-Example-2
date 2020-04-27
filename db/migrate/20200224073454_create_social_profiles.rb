class CreateSocialProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :social_profiles do |t|
      t.belongs_to :user
      t.string :platform  
      t.string :uuid
      t.timestamps
    end
  end
end
