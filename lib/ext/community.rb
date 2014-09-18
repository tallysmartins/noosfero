require_dependency 'community'

class Community

  attr_accessible :visible

  has_one :software_info, :dependent=>:delete
  has_one :institution, :dependent=>:delete

  def self.create_after_moderation(requestor, attributes = {}, software_info = nil, license_info = nil, controlled_vocabulary = nil)
    community = Community.new(attributes)

    if not software_info.nil?
      if not license_info.nil?
        software_info.license_info = license_info
      end

      if not controlled_vocabulary.nil?
        software_info.controlled_vocabulary = controlled_vocabulary
      end
      software_info.save
    end

    if community.environment.enabled?('admin_must_approve_new_communities')
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
