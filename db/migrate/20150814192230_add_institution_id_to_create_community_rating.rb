class AddInstitutionIdToCreateCommunityRating < ActiveRecord::Migration
  def up
    change_table :community_ratings do |t|
      t.belongs_to :institution
    end
  end

  def down
    remove_column :community_ratings, :institution_id
  end
end
