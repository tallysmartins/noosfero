class CreateSoftwareLanguagesTable < ActiveRecord::Migration
  def self.up
    create_table :software_languages do |t|
      t.references :software_info
      t.references :programming_language
      t.string :version
      t.string :operating_system
    end
  end

  def self.down
    drop_table :software_languages
  end
end
