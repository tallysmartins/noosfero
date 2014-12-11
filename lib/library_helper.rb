module LibraryHelper
  def self.list_libraries new_libraries
    return [] if new_libraries.nil? or new_libraries.length == 0
    list_libraries = []

    new_libraries.each do |new_library|
      unless SoftwareHelper.all_table_is_empty? new_library
        library = Library.new
        library.name = new_library[:name]
        library.version = new_library[:version]
        library.license = new_library[:license]
        list_libraries << library
      end
    end

    list_libraries
  end

  def self.valid_list_libraries? list_libraries
    return true if list_libraries.nil? or list_libraries.length == 0

    list_libraries.each do |library|
      return false unless library.valid?
    end

    true
  end

  def self.library_as_tables list_libraries
    extend(
      ActionView::Helpers::TagHelper,
      ActionView::Helpers::FormTagHelper,
      ActionView::Helpers::UrlHelper,
      ApplicationHelper
    )

    return library_html_structure({:name=>"", :version=>"", :license=>""}) if list_libraries.nil?

    lambdas_list = []

    list_libraries.each do |library|
      lambdas_list << library_html_structure(library)
    end

    lambdas_list
  end

  def self.library_html_structure library_data
    Proc::new do
      content_tag('table',
        content_tag('tr',
          content_tag('td', label_tag(_("Name")))+
          content_tag('td', text_field_tag("library[][name]", library_data[:name]))+
          content_tag('td')
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("Version")))+
          content_tag('td', text_field_tag("library[][version]", library_data[:version]))+
          content_tag('td')
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("License")))+
          content_tag('td', text_field_tag("library[][license]", library_data[:license])) +
          content_tag('td',
            button_without_text(:delete, _('Delete'), "#" , :class=>"delete-dynamic-table"),
            :align => 'right'
          )
        ), :class => 'dynamic-table library-table'
      )
    end
  end

  def self.add_dynamic_table
    library_as_tables(nil).call
  end
end
