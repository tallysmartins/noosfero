require_dependency "community_rating"

CommunityRating.class_eval do
  attr_accessible :institution_id

  belongs_to :institution

  validate :verify_institution

  private

    def verify_institution
      if self.institution_id != nil
        institution = Institution.find_by_id self.institution_id
        self.errors.add :institution, _("not found") unless institution
      end
    end
end
