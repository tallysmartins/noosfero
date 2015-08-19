require_dependency 'community'

class Community

  SEARCHABLE_SOFTWARE_FIELDS = {
    :name => 1,
    :identifier => 2,
    :nickname => 3
  }

  attr_accessible :visible

  has_one :software_info, :dependent=>:destroy

  settings_items :hits, :type => :integer, :default => 0

  def self.create_after_moderation(requestor, attributes = {})
    community = Community.new(attributes)

    if community.environment.enabled?('admin_must_approve_new_communities') &&
      !community.environment.admins.include?(requestor)

      cc = CreateCommunity.create(attributes.merge(:requestor => requestor))
    else
      community = Community.create(attributes)
      community.add_admin(requestor)
    end
    community
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

  def software?
    return !software_info.nil?
  end

  def deactivate
   self.visible = false
   self.save!
  end

  def activate
   self.visible = true
   self.save!
  end

  def remove_of_community_search_software?
    return software?
  end
  
  def hit
    self.hits += 1
    self.save!
  end

end
