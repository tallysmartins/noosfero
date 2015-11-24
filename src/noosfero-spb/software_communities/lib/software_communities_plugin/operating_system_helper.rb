class SoftwareCommunitiesPlugin::OperatingSystemHelper < SoftwareCommunitiesPlugin::DynamicTableHelper
  #FIXME Verify model_name
  MODEL_NAME = "software_communities_plugin/operating_system"
  FIELD_NAME = "operating_system_name_id"

  def self.list_operating_system new_operating_systems
    return [] if new_operating_systems.nil? or new_operating_systems.length == 0
    list_operating_system = []

    new_operating_systems.each do |new_operating_system|
      unless SoftwareCommunitiesPlugin::SoftwareHelper.all_table_is_empty?(
          new_operating_system,
          ["operating_system_name_id"]
        )

        operating_system = SoftwareCommunitiesPlugin::OperatingSystem.new
        operating_system.operating_system_name = SoftwareCommunitiesPlugin::OperatingSystemName.find(
          new_operating_system[:operating_system_name_id]
        )

        operating_system.version = new_operating_system[:version]
        list_operating_system << operating_system
      end
    end
    list_operating_system
  end

  def self.valid_list_operating_system? list_operating_system
    return false if (list_operating_system.nil? || list_operating_system.length == 0)
    return !list_operating_system.any?{|os| !os.valid?}
  end

  def self.operating_system_as_tables(list_operating_system, disabled=false)
    model_list = list_operating_system
    model_list ||= [{:operating_system_name_id => "", :version => ""}]

    models_as_tables model_list, "operating_system_html_structure", disabled
  end

  def self.operating_system_html_structure (operating_system_data, disabled)
    select_options = options_for_select(
      SoftwareCommunitiesPlugin::OperatingSystemName.all.collect {|osn| [osn.name, osn.id]},
      operating_system_data[:operating_system_name_id]
    )

    data = {
      #FIXME Verify model_name
      model_name: MODEL_NAME,
      field_name: FIELD_NAME,
      name: {
        hidden: false,
        autocomplete: false,
        select_field: true,
        options: select_options
      },
      version: {
        value: operating_system_data[:version],
        hidden: true,
        delete: true
      }
    }
    DATA[:license].delete(:value)
    table_html_structure(data, disabled)
  end

  def self.add_dynamic_table
    operating_system_as_tables(nil).first.call
  end
end
