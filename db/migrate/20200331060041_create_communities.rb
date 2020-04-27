class CreateCommunities < ActiveRecord::Migration[5.2]
  def change
    create_table :communities do |t|
      t.belongs_to :creator, foreign_key: { to_table: 'users' }
      t.integer :member_ids, array: true, default: []
      t.string :name
      t.boolean :flag_active, default: true
      t.timestamps
    end
  end
end
