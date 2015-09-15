class AddPeopleBenefitedAndSavedValueToOrganizationRating < ActiveRecord::Migration
  def up
    add_column :organization_ratings, :people_benefited, :integer
    add_column :organization_ratings, :saved_value, :decimal
  end

  def down
    remove_column :organization_ratings, :people_benefited
    remove_column :organization_ratings, :saved_value
  end
end
