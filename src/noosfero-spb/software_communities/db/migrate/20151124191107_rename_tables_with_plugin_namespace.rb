class RenameTablesWithPluginNamespace < ActiveRecord::Migration
  def change
    rename_table :programming_languages, :software_communities_plugin_programming_languages
    rename_table :license_infos, :software_communities_plugin_license_infos
    rename_table :software_languages, :software_communities_plugin_software_languages
    rename_table :libraries, :software_communities_plugin_libraries
    rename_table :database_descriptions, :software_communities_plugin_database_descriptions
    rename_table :software_infos, :software_communities_plugin_software_infos
    rename_table :operating_systems, :software_communities_plugin_operating_systems
    rename_table :operating_system_names, :software_communities_plugin_operating_system_names
    rename_table :software_databases, :software_communities_plugin_software_databases
  end
end
