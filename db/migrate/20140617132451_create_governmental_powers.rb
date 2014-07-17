class CreateGovernmentalPowers < ActiveRecord::Migration
  def change
    create_table :governmental_powers do |t|
      t.string :name

      t.timestamps
    end

    SoftwareHelper.create_list_with_file("plugins/mpog_software/public/static/governmental_powers.txt", GovernmentalPower)
  end
end
