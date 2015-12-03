class SoftwareLanguageHelper < DynamicTableHelper
  MODEL_NAME ="language"
  FIELD_NAME = "programming_language_id"

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
    model_list = list_languages
    model_list ||= [{:programming_language_id => "", :version => ""}]

    models_as_tables model_list, "language_html_structure", disabled
  end

  def self.language_html_structure(language_data, disabled)
    language_id = language_data[:programming_language_id]
    language_name = ""
    unless language_data[:programming_language_id].blank?
      language_name = ProgrammingLanguage.find(
        language_data[:programming_language_id],
        :select=>"name"
      ).name
    end

    data = {
      model_name: MODEL_NAME,
      field_name: FIELD_NAME,
      name: {
        value: language_name,
        id: language_id,
        hidden: true,
        autocomplete: true,
        select_field: false
      },
      version: {
        value: language_data[:version],
        hidden: true,
        delete: true
      }
    }
    DATA[:license].delete(:value)
    table_html_structure(data, disabled)
  end

  def self.add_dynamic_table
    language_as_tables(nil).first.call
  end
end
