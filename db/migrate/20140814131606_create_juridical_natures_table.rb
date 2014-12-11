class CreateJuridicalNaturesTable < ActiveRecord::Migration
  def up
    create_table :juridical_natures do |t|
      t.string :name
    end

    PATH_TO_FILE="plugins/mpog_software/public/static/juridical_nature.txt"
    SoftwareHelper.create_list_with_file(PATH_TO_FILE, JuridicalNature)
  end

  def down
    drop_table :juridical_natures
  end
end
