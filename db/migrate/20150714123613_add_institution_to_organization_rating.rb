class AddInstitutionToOrganizationRating < ActiveRecord::Migration
  def up
    change_table :organization_ratings do |t|
      t.belongs_to :institution
    end
  end

  def down
    remove_column :organization_ratings, :institution_id
  end
end
