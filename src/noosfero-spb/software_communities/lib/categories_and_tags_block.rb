class CategoriesAndTagsBlock < Block

  attr_accessible :show_name
  attr_accessible :search_catalog

  settings_items :show_name, :type => :boolean, :default => false
  settings_items :search_catalog, :type => :string, :default => SearchController.catalog_list[:public_software].last

  def self.description
    _('Categories and Tags')
  end

  def help
    _('This block displays the categories and tags of a software.')
  end

  def content(args={})
    block = self
    s = show_name
    lambda do |object|
      render(
        :file => 'blocks/categories_and_tags',
        :locals => { :block => block, :show_name => s }
      )
    end
  end

  def cacheable?
    false
  end
end
