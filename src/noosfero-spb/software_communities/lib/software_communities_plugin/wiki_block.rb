class SoftwareCommunitiesPlugin::WikiBlock < Block

  attr_accessible :show_name, :wiki_link
  settings_items :show_name, :type => :boolean, :default => false
  settings_items :wiki_link, :type => :string, :default => ""

  def self.description
    _('Wiki Link')
  end

  def help
    _('This block displays a link to the software wiki.')
  end

  def content(args={})
    block = self
    s = show_name

    lambda do |object|
      render(
        :file => 'blocks/wiki',
        :locals => { :block => block, :show_name => s }
      )
    end
  end

  def cacheable?
    true
  end
end
