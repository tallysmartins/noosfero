class AddReferencesToInstitution < ActiveRecord::Migration
  def up
    change_table :institutions do |t|
      t.references :governmental_power
      t.references :governmental_sphere
    end
  end

  def down
    change_table :institutions do |t|
      t.remove_references :governmental_power
      t.remove_references :governmental_sphere
    end
  end
end
