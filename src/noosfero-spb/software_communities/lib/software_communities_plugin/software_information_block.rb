class SoftwareCommunitiesPlugin::SoftwareInformationBlock < Block

  attr_accessible :show_name

  settings_items :show_name, :type => :boolean, :default => false

  def self.description
    _('Basic Software Information')
  end

  def help
    _('This block displays the basic information of a software profile.')
  end

  def content(args={})
    block = self
    s = show_name

    lambda do |object|
      render(
        :file => 'blocks/software_information',
        :locals => { :block => block, :show_name => s}
      )
    end
  end

  def cacheable?
    false
  end

  private

  def owner_has_ratings?
    ratings = OrganizationRating.where(community_id: block.owner.id)
    !ratings.empty?
  end
end
