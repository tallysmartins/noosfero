class AddExtraFieldsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :secondary_email
      t.references :institution
      t.string :role
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :secondary_email
      t.remove_references :institution
      t.remove :role
    end
  end
end
