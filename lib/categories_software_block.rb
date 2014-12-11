class CategoriesSoftwareBlock < Block

  attr_accessible :show_name

  settings_items :show_name, :type => :boolean, :default => false

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
    lambda do |object|
      render(
        :file => 'blocks/categories_software',
        :locals => { :block => block, :show_name => s }
      )
    end
  end

  def cacheable?
    false
  end
end
