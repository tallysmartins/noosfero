module SoftwareLanguageHelper

  def self.valid_language? language
    return false if SoftwareHelper.all_table_is_empty?(language)

    programming_language_id_list = ProgrammingLanguage.select(:id).collect {|dd| dd.id }

    return false unless programming_language_id_list.include?(language[:programming_language_id].to_i)

    true
  end

  def self.list_language new_languages
    return [] if new_languages.nil? or new_languages.length == 0
    list_languages = []

    new_languages.each do |new_language|
      if valid_language? new_language
        language = SoftwareLanguage.new
        language.programming_language = ProgrammingLanguage.find(new_language[:programming_language_id])
        language.version = new_language[:version]
        language.operating_system = new_language[:operating_system]
        list_languages << language
      end
    end

    list_languages
  end

  def self.valid_list_language? list_languages
    return false if list_languages.nil? or list_languages.length == 0

    list_languages.each do |language|
      return false unless language.valid?
    end

    true
  end

  def self.language_as_tables(list_languages, show_information = false)
    extend(
      ActionView::Helpers::TagHelper,
      ActionView::Helpers::FormTagHelper,
      ActionView::Helpers::UrlHelper,
      ActionView::Helpers::FormOptionsHelper,
      ApplicationHelper
    )
    
    lambdas_list = []

    if not show_information
      return language_html_structure({:programming_language_id => "", :version => "", :operating_system => ""}) if list_languages.nil?

      list_languages.each do |language|
        lambdas_list << language_html_structure(language)
      end

    else 
      list_languages.each do |language|
        lambdas_list << language_html_show_structure(language)
      end

    end

    lambdas_list
  end

  def self.language_html_structure(language_data)
    language_name = if language_data[:programming_language_id].blank?
      ""
    else
      ProgrammingLanguage.find(language_data[:programming_language_id], :select=>"name").name
    end

    Proc::new do
      content_tag('table',
        content_tag('tr',
          content_tag('td', label_tag(_("Language Name: ")))+
          content_tag('td',
            text_field_tag("language_autocomplete", language_name, :class=>"language_autocomplete") +
            content_tag('div', _("Pick an item on the list"), :class=>"autocomplete_validation_message hide-field") ) +
          content_tag('td', hidden_field_tag("language[][programming_language_id]", language_data[:programming_language_id], :class=>"programming_language_id", data:{label:language_name}))
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("Version")))+
          content_tag('td', text_field_tag("language[][version]", language_data[:version]))+
          content_tag('td')
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("Operating System")))+
          content_tag('td', text_field_tag("language[][operating_system]", language_data[:operating_system]))+
          content_tag('td', button_without_text(:delete, _('Delete'), "#" , :class=>"delete-dynamic-table"), :align => 'right')
        ), :class => 'dynamic-table software-language-table'
      )
    end
  end

  def self.language_html_show_structure(language)
     Proc::new do
      content_tag('table',
        content_tag('tr',
          content_tag('td', label_tag(_("Language Name: ")))+
          content_tag('td', ProgrammingLanguage.where(:id => language[:programming_language_id])[0].name)+
          content_tag('td')
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("Version")))+
          content_tag('td', language[:version])+
          content_tag('td')
        )+

        content_tag('tr',
          content_tag('td', label_tag(_("Operating System")))+
          content_tag('td', language[:operating_system])+
          content_tag('td', "")
        ), :class => 'dynamic-table software-language-table'
      )
    end
  end

  def self.add_dynamic_table
    language_as_tables(nil).call
  end
end
