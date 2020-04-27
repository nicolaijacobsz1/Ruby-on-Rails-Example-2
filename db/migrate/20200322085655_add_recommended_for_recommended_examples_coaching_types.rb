class AddRecommendedForRecommendedExamplesCoachingTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :coaching_types, :recommended_for, :string
    add_column :coaching_types, :recommended_examples, :string
  end
end
