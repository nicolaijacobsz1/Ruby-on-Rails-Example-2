class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.integer :coach_id
      t.string :title
      t.string :body
      t.integer :service_price_cents, default: 0
      t.string :service_price_currency
      t.string :attachment_id
      t.string :status, default: 'private'
      t.boolean :flag_active, default: true
  
      t.timestamps
    end
  end
end
