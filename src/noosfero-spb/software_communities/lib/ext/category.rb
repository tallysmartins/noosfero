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

  SEARCHABLE_SOFTWARE_FIELDS = {
    :name => 1
  }

  def software_infos
    softwares = self.all_children.collect{|c| c.software_communities} + software_communities
    softwares.flatten.uniq
  end

  def software_communities
    self.communities.collect{|community| community.software_info if community.software?}.compact
  end

  def name
    _(self[:name].to_s)
  end
end
