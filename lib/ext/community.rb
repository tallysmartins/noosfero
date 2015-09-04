require_dependency 'community'

class Community
  has_one :institution, :dependent=>:destroy

  def institution?
    return !institution.nil?
  end

  def remove_of_community_search_institution?
    return institution?
  end

  def self.get_valid_communities_string
    remove_of_communities_methods = Community.instance_methods.select{|m| m =~ /remove_of_community_search/}
    valid_communities_string = "!("
    remove_of_communities_methods.each do |method|
      valid_communities_string += "community.send('#{method}') || "
    end
    valid_communities_string = valid_communities_string[0..-5]
    valid_communities_string += ")"

    valid_communities_string
  end
end
