class AddFlagPrivateToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :flag_private, :boolean, default: false
  end
end

