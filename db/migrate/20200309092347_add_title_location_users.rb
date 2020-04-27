class AddTitleLocationUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :title, :string
    add_column :users, :location, :string

  end
end
