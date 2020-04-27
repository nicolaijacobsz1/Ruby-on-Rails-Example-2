class CreateFollowerRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :follower_requests do |t|
      t.integer :follower_id 
      t.integer :following_id
      t.string :aasm_state

      t.timestamps
    end
  end
end
