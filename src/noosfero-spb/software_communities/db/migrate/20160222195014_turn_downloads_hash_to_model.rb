class TurnDownloadsHashToModel < ActiveRecord::Migration
  def up
    DownloadBlock.find_each do |download_block|
      download_block.downloads.each do |download_hash|
        download_hash[:size] = "-" if download_hash[:size].blank?
      end

      # The method update_downloads will be called after_save
      download_block.save
    end
  end

  def down
    say 'This migration cannot be reversed'
  end
end
