require_dependency 'user'

class User

  belongs_to :institution

  validate :email_different_secondary?, :email_has_already_been_used?,
           :secondary_email_format, :email_suffix_is_gov?

  scope :primary_or_secondary_email_already_used?, lambda { |email|
    where("email=? OR secondary_email=?", email, email)
  }

  def email_different_secondary?
    self.errors.add(:base, _("Email must be different from secondary email.")) if self.email == self.secondary_email
  end

  def email_has_already_been_used?
    user_already_saved = User.find(:first, :conditions=>["email = ?", self.email])

    if user_already_saved.nil?
      primary_email_hasnt_been_used = User.primary_or_secondary_email_already_used?(self.email).empty?
      secondary_email_hasnt_been_used = User.primary_or_secondary_email_already_used?(self.secondary_email).empty?

      if !primary_email_hasnt_been_used or !secondary_email_hasnt_been_used
        self.errors.add(:base, _("E-mail or secondary e-mail already taken."))
      end
    end
  end

  def secondary_email_format
    if !self.secondary_email.nil? and self.secondary_email.length > 0
      test = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
      self.errors.add(:base, _("Invalid secondary email format.")) unless test.match(self.secondary_email)
    end
  end

  def email_suffix_is_gov?
    test = /^.*@[gov.br|jus.br|leg.br|mp.br]+$/
    primary_email_has_gov_suffix = false
    secondary_email_has_gov_suffix = false

    if !self.email.nil? and self.email.length > 0
      primary_email_has_gov_suffix = true  if test.match(self.email)
    end

    unless primary_email_has_gov_suffix
      if !self.secondary_email.nil? and self.secondary_email.length > 0
        secondary_email_has_gov_suffix = true if test.match(self.secondary_email)
      end
      self.errors.add(:base, _("The governamental email must be the primary one.")) if secondary_email_has_gov_suffix
    end

    self.errors.add(:base, _("Institution is obligatory if user has a government email.")) if primary_email_has_gov_suffix and self.institution.nil?
  end

end
