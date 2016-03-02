class CreateDownloadTable < ActiveRecord::Migration
  def up
    create_table :software_communities_downloads do |t|
      t.references :download_block
      t.string :name
      t.string :link
      t.string :software_description
      t.string :minimum_requirements
      t.string :size
      t.integer :total_downloads, :default => 0
    end
  end

  def down
    drop_table :downloads
  end
end
