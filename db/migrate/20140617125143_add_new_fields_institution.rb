class AddNewFieldsInstitution < ActiveRecord::Migration
  def up
    add_column :institutions, :acronym, :string
    add_column :institutions, :unit_code, :integer
    add_column :institutions, :parent_code, :integer
    add_column :institutions, :unit_type, :string
    add_column :institutions, :juridical_nature, :string
    add_column :institutions, :sub_juridical_nature, :string
    add_column :institutions, :normalization_level, :string
    add_column :institutions, :version, :string
    add_column :institutions, :cnpj, :string
    add_column :institutions, :type, :string
  end

  def down
    remove_column :institutions, :acronym
    remove_column :institutions, :unit_code
    remove_column :institutions, :parent_code
    remove_column :institutions, :unit_type
    remove_column :institutions, :juridical_nature
    remove_column :institutions, :sub_juridical_nature
    remove_column :institutions, :normalization_level
    remove_column :institutions, :version
    remove_column :institutions, :cnpj
    remove_column :institutions, :type
  end
end
