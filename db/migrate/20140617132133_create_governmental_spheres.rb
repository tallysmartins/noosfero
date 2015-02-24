class CreateGovernmentalSpheres < ActiveRecord::Migration
  def change
    create_table :governmental_spheres do |t|
      t.string :name

      t.timestamps
    end

    path_to_file = "plugins/software_communities/public/static/governmental_sphere.txt"
    SoftwareHelper.create_list_with_file(path_to_file, GovernmentalSphere)
  end
end
