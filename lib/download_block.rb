class DownloadBlock < Block

  attr_accessible :name, :link, :software_description, :show_name,
                  :version_news, :minimum_requirements, :downloads

  settings_items :name, :type => :string, :default => ''
  settings_items :link, :type => :string, :default => ''
  settings_items :software_description, :type => :string, :default => ''
  settings_items :show_name, :type => :boolean, :default => false
  settings_items :version_news, :type => :string, :default => ''
  settings_items :minimum_requirements, :type => :string, :default => ''
  settings_items :downloads, :type => Array, :default => []

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
