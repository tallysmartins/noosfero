require_dependency 'community'

class Community

  attr_accessible :visible

  has_one :software_info, :dependent=>:destroy
  has_one :institution, :dependent=>:destroy

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

  def software?
    return !software_info.nil?
  end

  def institution?
    return !institution.nil?
  end

  def deactivate
   self.visible = false
   self.save!
  end

  def activate
   self.visible = true
   self.save!
  end
end
