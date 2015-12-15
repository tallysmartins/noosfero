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
    statistics = get_software_statistics

    lambda do |object|
      render(
        :file => 'blocks/software_statistics',
        :locals => {
          :block => block,
          :total_downloads => downloads.sum,
          :statistics => statistics
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

  def get_software_statistics
    statistics = {}
    software = SoftwareInfo.find_by_community_id(self.owner.id)
    if software.present?
      statistics[:saved_resources] = software.saved_resources
      statistics[:benefited_people] = software.benefited_people
    else
      statistics[:saved_resources] = 0
      statistics[:benefited_people] = 0
    end
    statistics
  end
end
