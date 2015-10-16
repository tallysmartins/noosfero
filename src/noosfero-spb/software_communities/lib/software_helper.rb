module SoftwareHelper
  def self.select_options programming_languages, selected = 0
    value = ""

    programming_languages.each do |language|
      selected = selected == language.id ? 'selected' : ''
      value += "<option value=#{language.id} #{selected}>
                  #{language.name}
                </option>"
    end

    value
  end

  def self.create_list_with_file file_name, model
    list_file = File.open file_name, "r"

    list_file.each_line do |line|
      model.create(:name=>line.strip)
    end

    list_file.close
  end

  def self.all_table_is_empty? table, ignored_fields=[]
    return !table.keys.any?{|key| ignored_fields.include?(key) ? false : !table[key].empty?}
  end
end
