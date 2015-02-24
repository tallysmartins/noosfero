class CreateProgrammingLanguagesTable < ActiveRecord::Migration
  def self.up
    create_table :programming_languages do |t|
      t.string :name
    end

    SoftwareHelper.create_list_with_file("plugins/software_communities/public/static/languages.txt", ProgrammingLanguage)
  end

  def self.down
    drop_table :programming_languages
  end
end
