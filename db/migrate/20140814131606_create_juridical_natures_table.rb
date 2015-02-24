class CreateJuridicalNaturesTable < ActiveRecord::Migration
  def up
    create_table :juridical_natures do |t|
      t.string :name
    end

    path_to_file = "plugins/software_communities/public/static/juridical_nature.txt"
    SoftwareHelper.create_list_with_file(path_to_file, JuridicalNature)
  end

  def down
    drop_table :juridical_natures
  end
end
