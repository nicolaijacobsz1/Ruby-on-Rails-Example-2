class AddFlagDraftToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :flag_draft, :boolean, default: false
  end
end
