class RemoveInstitutionFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :institution_id
  end

  def down
    add_column :users, :institution_id
  end
end
