class AddIndexFollowerFollowingIdFollowerRequests < ActiveRecord::Migration[5.2]
  def change
    add_index :follower_requests, :follower_id
    add_index :follower_requests, :following_id

  end
end
