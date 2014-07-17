module DatabaseHelper

  def self.list_database new_databases
    return [] if new_databases.nil? or new_databases.length == 0
    list_databases = []

    new_databases.each do |new_database|
      unless SoftwareHelper.all_table_is_empty? new_database, ["database_description_id"]
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

  def self.database_as_tables(list_databases, have_delete_button = nil)
    extend(
      ActionView::Helpers::TagHelper,
      ActionView::Helpers::FormTagHelper,
      ActionView::Helpers::UrlHelper,
      ActionView::Helpers::FormOptionsHelper,
      ApplicationHelper
    )

    return database_html_structure({:database_description_id => 1, :version => "", :operating_system => ""}, have_delete_button) if list_databases.nil?    

    lambdas_list = []
    
    list_databases.each do |database|
      lambdas_list << database_html_structure(database, have_delete_button)
    end

    lambdas_list
  end

  def self.database_html_structure(database_data, have_delete_button = nil)
    Proc::new do
      content_tag('table',
        content_tag('tr',
          content_tag('td', label_tag(_("database Name: ")))+
          content_tag('td', select_tag("database[][database_description_id]", SoftwareHelper.select_options(DatabaseDescription.all, database_data[:database_description_id]) ))+
          content_tag('td')
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("Version")))+
          content_tag('td', text_field_tag("database[][version]", database_data[:version]))+
          content_tag('td')
        )+

         content_tag('tr',
          content_tag('td', label_tag(_("Operating System")))+
          content_tag('td', text_field_tag("database[][operating_system]", database_data[:operating_system]))+
          
          if have_delete_button.nil?
              content_tag('td',
              button_without_text(:delete, _('Delete'), "#" , :class=>"delete-dynamic-table"),
              :align => 'right'
            )
          else
            content_tag('td')
          end
        ), :class => 'dynamic-table database-table'
      )
    end
  end

  def self.add_dynamic_table
    database_as_tables(nil).call
  end
end
