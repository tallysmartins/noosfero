require_dependency "organization_rating"

OrganizationRating.class_eval do

  belongs_to :institution

  attr_accessible :institution, :institution_id

  validate :verify_institution

  private

  def verify_institution
    if self.institution != nil
      institution = Institution.find_by_id self.institution.id
      self.errors.add :institution, _("institution not found") unless institution
      return !!institution
    end
  end

end
