class AddInstitutionIdToCreateCommunityRatingComment < ActiveRecord::Migration
  def up
    change_table :tasks do |t|
      t.belongs_to :institution
    end
  end

  def down
    remove_column :tasks, :institution_id
  end
end
