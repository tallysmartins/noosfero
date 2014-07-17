class CreateGovernmentalSpheres < ActiveRecord::Migration
  def change
    create_table :governmental_spheres do |t|
      t.string :name

      t.timestamps
    end

    SoftwareHelper.create_list_with_file("plugins/mpog_software/public/static/governmental_sphere.txt", GovernmentalSphere)
  end
end
