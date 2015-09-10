class AddSiorgCodeToInstitution < ActiveRecord::Migration
  def up
    add_column :institutions, :siorg_code, :integer
  end

  def down
    remove_column :institutions, :siorg_code
  end
end
