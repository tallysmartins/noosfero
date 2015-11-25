class CreateProgrammingLanguagesTable < ActiveRecord::Migration
  def self.up
    create_table :programming_languages do |t|
      t.string :name
    end
  end

  def self.down
    drop_table :programming_languages
  end
end
