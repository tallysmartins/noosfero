class SoftwareCommunitiesPlugin::LibraryHelper < SoftwareCommunitiesPlugin::DynamicTableHelper
  #FIXME Verify this name.
  MODEL_NAME = "software_communities_plugin/library"

  def self.list_library new_libraries
    return [] if new_libraries.nil? or new_libraries.length == 0
    list_libraries = []

    new_libraries.each do |new_library|
      unless SoftwareCommunitiesPlugin::SoftwareHelper.all_table_is_empty? new_library
        library = SoftwareCommunitiesPlugin::Library.new
        library.name = new_library[:name]
        library.version = new_library[:version]
        library.license = new_library[:license]
        list_libraries << library
      end
    end

    list_libraries
  end

  def self.valid_list_library? list_libraries
    return true if list_libraries.nil? or list_libraries.length == 0
    return !list_libraries.any?{|library| !library.valid?}
  end

  def self.libraries_as_tables list_libraries, disabled=false
    model_list = list_libraries
    model_list ||= [{:name=>"", :version=>"", :license=>""}]

    models_as_tables model_list, "library_html_structure", disabled
  end

  def self.library_html_structure library_data, disabled
    data = {
      #FIXME Verify MODEL_NAME
      model_name: MODEL_NAME,
      name: {
        value: library_data[:name],
        hidden: false,
        autocomplete: false,
        select_field: false
      },
      version: {
        value: library_data[:version],
        delete: false
      },
      license: {
        value: library_data[:license]
      }
    }

    table_html_structure(data, disabled)
  end

  def self.add_dynamic_table
    libraries_as_tables(nil).first.call
  end
end
