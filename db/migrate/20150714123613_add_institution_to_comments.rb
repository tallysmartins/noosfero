class AddInstitutionToComments < ActiveRecord::Migration
  def up
    change_table :comments do |t|
      t.belongs_to :institution
    end
  end

  def down
    remove_column :comments, :institution_id
  end
end
