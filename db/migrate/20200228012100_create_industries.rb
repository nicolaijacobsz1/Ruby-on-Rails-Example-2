class CreateIndustries < ActiveRecord::Migration[5.2]
  def change
    create_table :industries do |t|
      t.string :name
      t.string :description
      t.string :search_keyword, array: true, default: []
      t.boolean :flag_active, default: true
      t.timestamps
    end
  end
end
