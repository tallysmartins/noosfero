module SoftwareLanguageHelper
  MODEL_NAME = "language"
  FIELD_NAME = "programming_language_id"
  COLLUMN_NAME = {
    name: "name",
    version: "version"
  }

  def self.valid_language? language
    return false if SoftwareHelper.all_table_is_empty?(language)

    programming_language_id_list = ProgrammingLanguage.
                                     select(:id).
                                     collect { |dd| dd.id }

    return programming_language_id_list.include?(
             language[:programming_language_id].to_i
           )
  end

  def self.list_language new_languages
    return [] if new_languages.nil? or new_languages.length == 0
    list_languages = []

    new_languages.each do |new_language|
      if valid_language? new_language
        language = SoftwareLanguage.new
        language.programming_language =
          ProgrammingLanguage.find(new_language[:programming_language_id])
        language.version = new_language[:version]
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

  def self.language_as_tables(list_languages, disabled=false)
    return language_html_structure(
      {:programming_language_id => "", :version => ""}, disabled
    ) if list_languages.nil?

    lambdas_list = []

    list_languages.each do |language|
      lambdas_list << language_html_structure(language, disabled)
    end

    lambdas_list
  end

  def self.language_html_structure(language_data, disabled)
    language_id = language_data[:programming_language_id]
    language_name = if language_data[:programming_language_id].blank?
      ""
    else
      ProgrammingLanguage.find(
        language_data[:programming_language_id],
        :select=>"name"
      ).name
    end

    data = {
      model_name: MODEL_NAME,
      field_name: FIELD_NAME,
      name: {
        label: DynamicTableHelper::LABEL_TEXT[:name],
        value: language_name,
        hidden: true,
        autocomplete: true,
        name: COLLUMN_NAME[:name],
        id: language_id
      },
      version: {
        label: DynamicTableHelper::LABEL_TEXT[:version],
        value: language_data[:version],
        name: COLLUMN_NAME[:version],
        hidden: true,
        delete: true
      }
    }

    DynamicTableHelper.table_html_structure(data, disabled)
  end

  def self.add_dynamic_table
    language_as_tables(nil).call
  end
end
