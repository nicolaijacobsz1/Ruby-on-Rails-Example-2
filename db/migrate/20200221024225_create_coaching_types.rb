class CreateCoachingTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :coaching_types do |t|
      t.string :name
      t.string :description
      t.boolean :flag_active, default: true
      t.timestamps
    end
  end
end
