class Questions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :title
      t.text :body
      t.string :attachment
      t.string :user_id
      t.integer :coach_id #t.references :user
      t.boolean :flag_schedule, default: false
      t.boolean :flag_active, default: true
      #t.boolean :flag_draft, default: false

      t.timestamps

    end
  end
end
