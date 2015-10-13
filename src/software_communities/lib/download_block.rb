class DownloadBlock < Block

  attr_accessible :show_name, :downloads

  settings_items :show_name, :type => :boolean, :default => false
  settings_items :downloads, :type => Array, :default => []

  validate :download_values

  def download_values
    self.downloads = Download.validate_download_list(self.downloads)
  end

  def self.description
    _('Download Stable Version')
  end

  def help
    _('This block displays the stable version of a software.')
  end

  def content(args={})
    block = self
    s = show_name
    lambda do |object|
      render(
        :file => 'blocks/download',
        :locals => { :block => block, :show_name => s }
      )
    end
  end

  def cacheable?
    false
  end
end
