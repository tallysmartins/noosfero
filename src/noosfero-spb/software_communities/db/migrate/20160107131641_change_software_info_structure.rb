class ChangeSoftwareInfoStructure < ActiveRecord::Migration
  def up
    change_table :software_communities_plugin_software_infos do |t|
      t.text :sisp_url
      t.text :agency_identification
      t.text :software_requirements
      t.text :hardware_requirements
      t.text :documentation
      t.text :system_applications
      t.text :active_versions
      t.text :estimated_cost
      t.text :responsible
      t.text :responsible_for_acquirement
      t.text :system_info
      t.text :development_info
      t.text :maintenance
      t.text :standards_adherence
      t.text :platform
      t.text :sisp_type
      t.integer :sisp_id
    end

    change_column :software_communities_plugin_software_infos, :finality, :text
  end

  def down
    remove_column :software_communities_plugin_software_infos, :agency_identification
    remove_column :software_communities_plugin_software_infos, :software_requirements
    remove_column :software_communities_plugin_software_infos, :hardware_requirements
    remove_column :software_communities_plugin_software_infos, :documentation
    remove_column :software_communities_plugin_software_infos, :system_applications
    remove_column :software_communities_plugin_software_infos, :active_versions
    remove_column :software_communities_plugin_software_infos, :estimated_cost
    remove_column :software_communities_plugin_software_infos, :responsible
    remove_column :software_communities_plugin_software_infos, :responsible_for_acquirement
    remove_column :software_communities_plugin_software_infos, :system_info
    remove_column :software_communities_plugin_software_infos, :development_info
    remove_column :software_communities_plugin_software_infos, :maintenance
    remove_column :software_communities_plugin_software_infos, :standards_adherence
    remove_column :software_communities_plugin_software_infos, :platform
    remove_column :software_communities_plugin_software_infos, :sisp_type
    remove_column :software_communities_plugin_software_infos, :sisp_id
    remove_column :software_communities_plugin_software_infos, :sisp_url
  end
end
