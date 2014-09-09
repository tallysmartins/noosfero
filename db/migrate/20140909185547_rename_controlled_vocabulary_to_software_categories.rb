class RenameControlledVocabularyToSoftwareCategories < ActiveRecord::Migration
  def up
    rename_table :controlled_vocabulary, :software_categories
  end

  def down
    rename_table :software_categories, :controlled_vocabulary
  end
end
