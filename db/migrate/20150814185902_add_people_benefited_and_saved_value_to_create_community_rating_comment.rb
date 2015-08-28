class AddPeopleBenefitedAndSavedValueToCreateCommunityRatingComment < ActiveRecord::Migration
  def up
    add_column :tasks, :people_benefited, :integer
    add_column :tasks, :saved_value, :decimal
  end

  def down
    remove_column :tasks, :people_benefited
    remove_column :tasks, :saved_value
  end
end
