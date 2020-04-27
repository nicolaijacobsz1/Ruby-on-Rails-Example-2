class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :attachment
      t.integer :coach_id #t.references :user
      t.integer :likes, default: 0
      t.boolean :flag_schedule, default: false
      t.boolean :flag_active, default: true
      #t.boolean :flag_draft, default: false

      t.timestamps
    end
  end
end
