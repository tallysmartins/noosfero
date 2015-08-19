class StatisticBlock < Block

  settings_items :benefited_people, :type => :integer, :default => 0
  settings_items :saved_resources, :type => :float, :default => 0.0

  attr_accessible :benefited_people, :saved_resources

  def self.description
    _('Software Statistics')
  end

  def help
    _('This block displays software statistics.')
  end

  def content(args={})
    download_blocks = get_profile_download_blocks(self.owner)
    downloads = download_blocks.map do |download_block|
      get_downloads_from_block(download_block)
    end

    block = self

    lambda do |object|
      render(
        :file => 'blocks/software_statistics',
        :locals => {
          :block => block,
          :total_downloads => downloads.sum
        }
      )
    end
  end

  def cacheable?
    false
  end

  private

  def get_profile_download_blocks profile
    DownloadBlock.joins(:box).where("boxes.owner_id = ?", profile.id)
  end

  def get_downloads_from_block download_block
    downloads = download_block.downloads.map do |download|
      download[:total_downloads] unless download[:total_downloads].nil?
    end
    downloads.select! {|value| not value.nil? }
    downloads.sum
  end
end
