class CreateProgrammingLanguagesTable < ActiveRecord::Migration
  def self.up
    create_table :programming_languages do |t|
      t.string :name
    end

    file_name = "plugins/software_communities/public/static/languages.txt"
    list_file = File.open file_name, "r"
    list_file.each_line do |line|
      execute("INSERT INTO programming_languages (name) VALUES ('#{line.strip}')")
    end
    list_file.close
  end

  def self.down
    drop_table :programming_languages
  end
end
