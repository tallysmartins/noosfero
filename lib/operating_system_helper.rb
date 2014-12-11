module OperatingSystemHelper
  def self.list_operating_system new_operating_systems
    return [] if new_operating_systems.nil? or new_operating_systems.length == 0
    list_operating_system = []

    new_operating_systems.each do |new_operating_system|
      unless SoftwareHelper.all_table_is_empty?(
          new_operating_system,
          ["operating_system_name_id"]
        )

        operating_system = OperatingSystem.new
        operating_system.operating_system_name = OperatingSystemName.find(
          new_operating_system[:operating_system_name_id]
        )

        operating_system.version = new_operating_system[:version]
        list_operating_system << operating_system
      end
    end
    list_operating_system
  end

  def self.valid_list_operating_system? list_operating_system
    return !(list_operating_system.nil? || list_operating_system.length == 0)

    list_operating_system.each do |operating_system|
      return false unless operating_system.valid?
    end
    true
  end

  def self.operating_system_as_tables(list_operating_system, have_delete_button = true, show_information = false)
    extend(
      ActionView::Helpers::TagHelper,
      ActionView::Helpers::FormTagHelper,
      ActionView::Helpers::UrlHelper,
      ActionView::Helpers::FormOptionsHelper,
      ApplicationHelper
    )

    lambdas_list = []

    if not show_information
      return operating_system_html_structure(
        {:operating_system_name_id => "", :version => ""},
        have_delete_button
      ) if list_operating_system.nil?

    list_operating_system.each do |operating_system|
      lambdas_list << operating_system_html_structure(
        operating_system,
        have_delete_button
      )
    end
    else
    list_operating_system.each do |operating_system|
      lambdas_list << operating_system_html_structure(operating_system)
    end
    end

    lambdas_list
  end

  def self.operating_system_html_structure (operating_system_data,have_delete_button = true)
    Proc::new do
      content_tag(
        'table',
        content_tag(
          'tr',
          content_tag('td', label_tag(_("Name")))+
          content_tag(
            'td',
            select_tag(
              "operating_system[][operating_system_name_id]",
              SoftwareHelper.select_options(
                  OperatingSystemName.all,
                  operating_system_data[:operating_system_name_id]
                )
              )
            )+
          content_tag('td')
        )+

        content_tag(
          'tr',
          content_tag('td', label_tag(_("Version")))+
          content_tag(
            'td',
            text_field_tag(
              "operating_system[][version]",
              operating_system_data[:version]
            )
          )+
          if have_delete_button
            content_tag(
              'td',
              button_without_text(
                :delete,
                _('Delete'),
                "#" ,
                :class=>"delete-dynamic-table"
              ),
              :align => 'right'
            )
          else
            content_tag('td', "")
          end
        ),:class => 'dynamic-table library-table'
      )
    end
  end

  def self.add_dynamic_table
    operating_system_as_tables(nil).call
  end
end
