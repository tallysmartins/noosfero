require_dependency "organization_rating"

OrganizationRating.class_eval do

  belongs_to :institution

  attr_accessible :institution, :institution_id

  validate :verify_institution, :verify_organization_rating_values

  private

  def verify_institution
    if self.institution != nil
      institution = Institution.find_by_id self.institution.id
      self.errors.add :institution, _("institution not found") unless institution
      return !!institution
    end
  end

  def verify_organization_rating_values
    if self.institution.nil? && (self.people_benefited || self.saved_value)
      self.errors.add :institution, _("Report values cannot be saved without an institution")
      false
    end
  end

end
