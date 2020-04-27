class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.text :body
      t.string :attachment
      t.belongs_to  :user
      t.belongs_to :post
      t.integer :likes, default: 0
      t.boolean :flag_active, default: true

      t.timestamps
    end
  end
end
