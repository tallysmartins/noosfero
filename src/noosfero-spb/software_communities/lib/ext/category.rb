require_dependency 'category'

class Category
  SOFTWARE_CATEGORIES = [
    _('Agriculture, Fisheries and Extraction'),
    _('Science, Information and Communication'),
    _('Economy and Finances'),
    _('Public Administration'),
    _('Habitation, Sanitation and Urbanism'),
    _('Individual, Family and Society'),
    _('Health'),
    _('Social Welfare and Development'),
    _('Defense and Security'),
    _('Education'),
    _('Government and Politics'),
    _('Justice and Legislation'),
    _('International Relationships'),
    _('Transportation and Transit')
  ]

  scope :software_categories, lambda {
    software_category = Category.find_by_name("Software")
    if software_category.nil?
      []
    else
      software_category.children
    end
  }

  def software_infos
    software_list = self.communities.collect{|community| community.software_info if community.software?}
    software_list
  end
end
