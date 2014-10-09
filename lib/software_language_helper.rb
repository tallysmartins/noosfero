module SoftwareLanguageHelper

  def self.list_language new_languages
    return [] if new_languages.nil? or new_languages.length == 0
    list_languages = []

    new_languages.each do |new_language|
      unless SoftwareHelper.all_table_is_empty? new_language, ["programming_language_id"]
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
      return language_html_structure({:programming_language_id => 1, :version => "", :operating_system => ""}) if list_languages.nil?

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
    Proc::new do
      content_tag('table',
        content_tag('tr',
          content_tag('td', label_tag(_("Language Name: ")))+
          content_tag('td', select_tag("language[][programming_language_id]", SoftwareHelper.select_options(ProgrammingLanguage.all, language_data[:programming_language_id]) ))+
          content_tag('td')
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
