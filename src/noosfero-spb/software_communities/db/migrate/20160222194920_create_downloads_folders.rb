class CreateDownloadsFolders < ActiveRecord::Migration
  def up
    SoftwareInfo.find_each do |software|
      community = software.community
      downloads_folder = Folder.find_or_create_by_profile_id_and_name(community.id, "Downloads")
    end
  end

  def down
    say 'This migration cannot be reversed'
  end
end
