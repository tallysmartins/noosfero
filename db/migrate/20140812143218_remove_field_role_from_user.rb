class RemoveFieldRoleFromUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.remove :role 
    end
  end

  def down
    change_table :users do |t|
      t.string :role 
    end
  end
end
