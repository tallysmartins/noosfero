class CreateGovernmentalPowers < ActiveRecord::Migration
  def change
    create_table :governmental_powers do |t|
      t.string :name

      t.timestamps
    end
  end
end
