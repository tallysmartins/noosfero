require_dependency 'create_community'

class CreateCommunity
  settings_items :software_info
  attr_accessible :software_info, :environment, :name, :closed, :template_id, :requestor, :reject_explanation, :target, :image_builder

  def perform
    community = Community.new
    community_data = self.data.reject do |key, value|
      ! DATA_FIELDS.include?(key.to_s)
    end

    community.update_attributes(community_data)
    community.image = image if image
    community.environment = self.environment
    community.software_info = self.software_info
    community.save!
    community.add_admin(self.requestor)
  end
end