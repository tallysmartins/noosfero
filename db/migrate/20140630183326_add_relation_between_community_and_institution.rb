class AddRelationBetweenCommunityAndInstitution < ActiveRecord::Migration
  def up
    change_table :institutions do |t|
      t.references :community
    end
  end

  def down
    change_table :institutions do |t|
      t.remove_references :community
    end
  end
end
