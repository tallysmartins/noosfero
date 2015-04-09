class CreateJuridicalNaturesTable < ActiveRecord::Migration
  def up
    create_table :juridical_natures do |t|
      t.string :name
    end
  end

  def down
    drop_table :juridical_natures
  end
end
