module DatabaseHelper

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
    extend(
      ActionView::Helpers::TagHelper,
      ActionView::Helpers::FormTagHelper,
      ActionView::Helpers::UrlHelper,
      ActionView::Helpers::FormOptionsHelper,
      ApplicationHelper
    )

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
    database_name, database_id = if database_data[:database_description_id].blank?
      ["", ""]
    else
      [DatabaseDescription.find(
        database_data[:database_description_id],
        :select=>"name"
      ).name, database_data[:database_description_id]]
    end

    data = {
      model_name: "database",
      field_name: "database_description_id",
      name: {
        label: _("Name"),
        value: database_name,
        hidden: true,
        autocomplete: true,
        id: database_id
      },
      version: {
        label: _("Version"),
        value: database_data[:version],
        hidden: true
      },
      operating_system: {
        label: _("Operating system"),
        value: database_data[:operating_system],
        delete: true
      }
    }

    DynamicTableHelper.table_html_structure(data)
  end

  def self.add_dynamic_table
    database_as_tables(nil).call
  end
end