require_dependency "create_organization_rating_comment"

CreateOrganizationRatingComment.class_eval do
  after_save :update_software_statistic

  def update_software_statistic
    if(self.status == Task::Status::FINISHED)
      rating = OrganizationRating.find_by_id(self.organization_rating_id)
      software = SoftwareCommunitiesPlugin::SoftwareInfo.find_by_community_id(self.target_id)
      if software.present? and rating.present?
        software.saved_resources += rating.saved_value if rating.saved_value
        software.benefited_people += rating.people_benefited if rating.people_benefited
        software.save
      end
    end
  end
end
