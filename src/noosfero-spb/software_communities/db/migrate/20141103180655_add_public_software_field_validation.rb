class AddPublicSoftwareFieldValidation < ActiveRecord::Migration
  def up
    add_column :software_infos, :public_software, :boolean, :default => false
  end

  def down
    remove_column :software_infos, :public_software
  end
end
