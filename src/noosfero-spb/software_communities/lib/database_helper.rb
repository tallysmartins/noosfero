class DatabaseHelper < DynamicTableHelper
  MODEL_NAME ="database"
  FIELD_NAME = "database_description_id"

  def self.valid_database? database
    return false if SoftwareHelper.all_table_is_empty?(database)

    database_description_id_list = DatabaseDescription.select(:id).
                                    collect {|dd| dd.id}

    return database_description_id_list.include?(
      database[:database_description_id].to_i
    )
  end

  def self.list_database new_databases
    return [] if new_databases.nil? or new_databases.length == 0
    list_databases = []

    new_databases.each do |new_database|
      if valid_database? new_database
        database = SoftwareDatabase.new

        database.database_description_id =
          new_database[:database_description_id]

        database.version = new_database[:version]
        list_databases << database
      end
    end

    list_databases
  end

  def self.valid_list_database? list_databases
    return false if list_databases.nil? or list_databases.length == 0
    return !list_databases.any?{|database| !database.valid?}
  end

  def self.database_as_tables(list_databases, disabled=false)
    model_list = list_databases
    model_list ||= [{:database_description_id => "", :version => ""}]

    models_as_tables model_list, "database_html_structure", disabled
  end

  def self.database_html_structure(database_data, disabled)
    database_id = database_data[:database_description_id]
    database_name = database_id.blank? ? "" : DatabaseDescription.find(
        database_data[:database_description_id],
        :select=>"name"
      ).name

    data = {
      model_name: MODEL_NAME,
      field_name: FIELD_NAME,
      name: {
        value: database_name,
        id: database_id,
        hidden: true,
        autocomplete: true,
        select_field: false
      },
      version: {
        value: database_data[:version],
        hidden: true,
        delete: true
      }
    }
    DATA[:license].delete(:value)
    table_html_structure(data, disabled)
  end

  def self.add_dynamic_table
    database_as_tables(nil).first.call
  end
end
