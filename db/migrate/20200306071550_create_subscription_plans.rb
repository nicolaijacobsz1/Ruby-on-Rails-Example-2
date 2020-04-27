class CreateSubscriptionPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :subscription_plans do |t|
      t.string :name
      t.string :description
      t.integer :price_cents
      t.string :price_currency
      t.boolean :flag_active, default: true
      t.timestamps
    end
  end
end
