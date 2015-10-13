class AddJuridicalNatureReferenceToInstitutionsTable < ActiveRecord::Migration
  def up
    change_table :institutions do |t|
      t.references :juridical_nature
    end
  end

  def down
    change_table :institutions do |t|
      t.remove_references :juridical_nature
    end
  end
end
