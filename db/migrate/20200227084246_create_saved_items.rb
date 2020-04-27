class CreateSavedItems < ActiveRecord::Migration[5.2]
  def change
    create_table :saved_items do |t|
      t.belongs_to :user
      t.belongs_to :post
      t.boolean :flag_active, default: true
      t.timestamps
    end
  end
end
