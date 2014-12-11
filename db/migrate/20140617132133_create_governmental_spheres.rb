class CreateGovernmentalSpheres < ActiveRecord::Migration
  def change
    create_table :governmental_spheres do |t|
      t.string :name

      t.timestamps
    end

    PATH_TO_FILE = "plugins/mpog_software/public/static/governmental_sphere.txt"
    SoftwareHelper.create_list_with_file(PATH_TO_FILE, GovernmentalSphere)
  end
end
