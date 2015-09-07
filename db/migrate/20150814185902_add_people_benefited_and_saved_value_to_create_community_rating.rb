class AddPeopleBenefitedAndSavedValueToCreateCommunityRating < ActiveRecord::Migration
  def up
    add_column :community_ratings, :people_benefited, :integer
    add_column :community_ratings, :saved_value, :decimal
  end

  def down
    remove_column :community_ratings, :people_benefited
    remove_column :community_ratings, :saved_value
  end
end
