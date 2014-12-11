class AddNewFieldsToPublicInstitution < ActiveRecord::Migration
  def up
    add_column :institutions, :sisp, :boolean, :default => false
    remove_column :institutions, :juridical_nature
  end

  def down
    remove_column :institutions, :sisp
    add_column :institutions, :juridical_nature, :string
  end
end
