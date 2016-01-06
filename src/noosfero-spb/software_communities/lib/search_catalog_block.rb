class SearchCatalogBlock < Block

  attr_accessible :show_name
  attr_accessible :search_catalog

  settings_items :show_name, :type => :boolean, :default => false
  settings_items :search_catalog, :type => :string, :default => SearchController.catalog_list[:public_software].last

  def self.description
    _('Search Softwares catalog')
  end

  def help
    _('This block displays the search categories field ')
  end

  def content(args={})
    block = self
    s = show_name
    lambda do |object|
      render(
        :file => 'blocks/search_catalog',
        :locals => { :block => block, :show_name => s }
      )
    end
  end

  def cacheable?
    false
  end
end
