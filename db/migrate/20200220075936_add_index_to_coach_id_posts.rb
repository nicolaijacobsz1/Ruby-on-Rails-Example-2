class AddIndexToCoachIdPosts < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :coach_id
  end
end
