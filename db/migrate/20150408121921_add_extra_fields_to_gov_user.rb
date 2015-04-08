class AddExtraFieldsToGovUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :secondary_email
      t.string :role
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :secondary_email
      t.remove :role
    end
  end
end
