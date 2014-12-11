class CreateGovernmentalPowers < ActiveRecord::Migration
  def change
    create_table :governmental_powers do |t|
      t.string :name

      t.timestamps
    end

    PATH_TO_FILE="plugins/mpog_software/public/static/governmental_powers.txt"
    SoftwareHelper.create_list_with_file(PATH_TO_FILE, GovernmentalPower)
  end
end
