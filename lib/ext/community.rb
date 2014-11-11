require_dependency 'community'

class Community

  attr_accessible :visible

  has_one :software_info, :dependent=>:destroy
  has_one :institution, :dependent=>:destroy

  def self.create_after_moderation(requestor, attributes = {}, software_info = nil, license_info = nil, software_categories = nil)
    community = Community.new(attributes)

    if not software_info.nil?
        if not license_info.nil?
          software_info.license_info = license_info
        end

        if not software_categories.nil?
          software_info.software_categories = software_categories
        end
      software_info.save
    end

    if community.environment.enabled?('admin_must_approve_new_communities') and !community.environment.admins.include?(requestor)
      cc = CreateCommunity.create(attributes.merge(:requestor => requestor, :software_info=>software_info))
    else
      community = Community.create(attributes)
      community.software_info = software_info
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
