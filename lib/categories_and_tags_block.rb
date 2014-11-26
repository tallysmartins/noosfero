class CategoriesAndTagsBlock < Block

  attr_accessible :show_name

  settings_items :show_name, :type => :boolean, :default => false

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
