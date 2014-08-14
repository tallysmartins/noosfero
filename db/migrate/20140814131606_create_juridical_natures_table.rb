class CreateJuridicalNaturesTable < ActiveRecord::Migration
  def up
    create_table :juridical_natures do |t|
      t.string :name
    end
    
    SoftwareHelper.create_list_with_file("plugins/mpog_software/public/static/juridical_nature.txt", JuridicalNature)
  end

  def down
    drop_table :juridical_natures 
  end
end
