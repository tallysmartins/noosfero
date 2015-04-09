class CreateGovernmentalSpheres < ActiveRecord::Migration
  def change
    create_table :governmental_spheres do |t|
      t.string :name
      t.string :acronym
      t.integer :unit_code
      t.integer :parent_code
      t.string :unit_type
      t.string :juridical_nature
      t.string :sub_juridical_nature
      t.string :normalization_level
      t.string :version
      t.string :cnpj
      t.string :type

      t.timestamps
    end
  end
end
