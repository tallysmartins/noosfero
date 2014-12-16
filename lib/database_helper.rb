module DatabaseHelper
  MODEL_NAME = "database"
  FIELD_NAME = "database_description_id"
  COLLUMN_NAME = {
    name: "name",
    version: "version",
    operating_system: "operating_system"
  }

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
        database.operating_system = new_database[:operating_system]
        list_databases << database
      end
    end

    list_databases
  end

  def self.valid_list_database? list_databases
    return false if list_databases.nil? or list_databases.length == 0

    list_databases.each do |database|
      return false unless database.valid?
    end

    true
  end

  def self.database_as_tables(list_databases)
    return database_html_structure(
      {:database_description_id => "", :version => "", :operating_system => ""}
    ) if list_databases.nil?

    lambdas_list = []

    list_databases.each do |database|
      lambdas_list << database_html_structure(database)
    end

    lambdas_list
  end

  def self.database_html_structure(database_data)
    database_id = database_data[:database_description_id]
    database_name = if database_data[:database_description_id].blank?
      ""
    else
      DatabaseDescription.find(
        database_data[:database_description_id],
        :select=>"name"
      ).name
    end

    data = {
      model_name: MODEL_NAME,
      field_name: FIELD_NAME,
      name: {
        label: DynamicTableHelper::LABEL_TEXT[:name],
        value: database_name,
        hidden: true,
        autocomplete: true,
        name: COLLUMN_NAME[:name],
        id: database_id
      },
      version: {
        label: DynamicTableHelper::LABEL_TEXT[:version],
        value: database_data[:version],
        name: COLLUMN_NAME[:version],
        hidden: true,
        delete: true
      }
    }

    DynamicTableHelper.table_html_structure(data)
  end

  def self.add_dynamic_table
    database_as_tables(nil).call
  end
end