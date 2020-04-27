class CreateTestimonials < ActiveRecord::Migration[5.2]
  def change
    create_table :testimonials do |t|
      t.belongs_to :user
      t.integer :testimonialable_id
      t.string :testimonialable_type
      t.string :title
      t.string :body
      t.integer :ratings, default: 0
      t.boolean :flag_active, default: true
      t.timestamps
    end
  end
end
