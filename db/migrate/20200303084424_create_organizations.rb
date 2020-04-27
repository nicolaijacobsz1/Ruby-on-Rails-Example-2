class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :description
      t.date :date_issued
      t.boolean :flag_active, default: true
      t.timestamps
  
    end
  end
end
