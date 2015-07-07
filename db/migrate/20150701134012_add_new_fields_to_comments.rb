class AddNewFieldsToComments < ActiveRecord::Migration
  def self.up
    change_table :comments do |t|
      t.integer :people_benefited
      t.decimal :saved_value
    end
  end

  def self.down
    remove_column :comments, :people_benefited
    remove_column :comments, :saved_value
  end
end
