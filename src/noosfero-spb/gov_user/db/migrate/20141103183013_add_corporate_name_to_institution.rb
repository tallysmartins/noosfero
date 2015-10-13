class AddCorporateNameToInstitution < ActiveRecord::Migration
  def up
    add_column :institutions, :corporate_name, :string
  end

  def down
    remove_column :institutions, :corporate_name
  end
end
