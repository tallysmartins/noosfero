class RegisterInstitutionModification < ActiveRecord::Migration
  def up
    change_table :institutions do |t|
      t.string :date_modification
    end
  end

  def down
    change_table :institutions do |t|
      t.remove :date_modification
    end
  end
end
