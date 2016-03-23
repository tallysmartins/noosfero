require_dependency 'category'

class Category
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
