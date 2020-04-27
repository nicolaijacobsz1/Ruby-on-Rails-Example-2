class CreateConfigurations < ActiveRecord::Migration[5.2]
  def change
    create_table :configurations do |t|
      t.string :name
      t.string :description
      t.string :param
      t.string :type
      t.string :value
      t.string :unit
      t.timestamps
    end
  end
end
