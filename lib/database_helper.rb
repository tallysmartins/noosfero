module DatabaseHelper

  def self.list_database new_databases
    return [] if new_databases.nil? or new_databases.length == 0
    list_databases = []

    new_databases.each do |new_database|
      unless SoftwareHelper.all_table_is_empty? new_database
        database = SoftwareDatabase.new
        database.database_description_id = new_database[:database_description_id]
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

    return database_html_structure({:database_description_id => "", :version => "", :operating_system => ""}) if list_databases.nil?

    lambdas_list = []

    list_databases.each do |database|
      lambdas_list << database_html_structure(database)
    end

    lambdas_list
  end

  def self.database_html_structure(database_data)
    database_name = if database_data[:database_description_id].blank?
      ""
    else
      DatabaseDescription.find(database_data[:database_description_id]).name
    end

    Proc::new do
      content_tag('table',
        content_tag('tr',
          content_tag('td', label_tag(_("database Name: ")))+
          content_tag('td',
            text_field_tag("database_autocomplete", database_name, :class=>"database_autocomplete") +
            content_tag('div', _("Pick an item on the list"), :class=>"autocomplete_validation_message hide-field")
          )+
          content_tag('td', hidden_field_tag("database[][database_description_id]", database_data[:database_description_id], :class=>"database_description_id", data:{label:database_name}))
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("Version")))+
          content_tag('td', text_field_tag("database[][version]", database_data[:version], :maxlength=>"20"))+
          content_tag('td')
        )+

         content_tag('tr',
          content_tag('td', label_tag(_("Operating System")))+
          content_tag('td', text_field_tag("database[][operating_system]", database_data[:operating_system], :maxlength=>"20"))+
          content_tag('td', button_without_text(:delete, _('Delete'), "#" , :class=>"delete-dynamic-table"), :align => 'right')
        ), :class => 'dynamic-table database-table'
      )
    end
  end

  def self.add_dynamic_table
    database_as_tables(nil).call
  end
end
