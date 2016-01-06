class CategoriesSoftwareBlock < Block

  attr_accessible :show_name
  attr_accessible :search_catalog

  settings_items :show_name, :type => :boolean, :default => false
  settings_items :search_catalog, :type => :string, :default => SearchController.catalog_list[:public_software].last

  def self.description
    _('Categories Softwares')
  end

  def help
    _('This block displays the categories and the amount of softwares for
      each category.')
  end

  def content(args={})
    block = self
    s = show_name

    software_category = environment.categories.find_by_name("Software")
    categories = []
    categories = software_category.children.sort if software_category

    lambda do |object|
      render(
        :file => 'blocks/categories_software',
        :locals => { :block => block, :show_name => s, :categories => categories }
      )
    end
  end

  def cacheable?
    false
  end
end
