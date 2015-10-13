require_dependency 'user'

class User

  GOV_SUFFIX = /^.*@[gov.br|jus.br|leg.br|mp.br]+$/

  has_and_belongs_to_many :institutions

  validate :email_different_secondary?, :email_has_already_been_used?,
  :secondary_email_format

  scope :primary_or_secondary_email_already_used?, lambda { |email|
    where("email=? OR secondary_email=?", email, email)
  }

  def email_different_secondary?
    self.errors.add(
    :base,
    _("Email must be different from secondary email.")
    ) if self.email == self.secondary_email
  end

  def email_has_already_been_used?
    user_already_saved = User.find(:first,
    :conditions => ["email = ?", self.email])

    if user_already_saved.nil?
      primary_email_hasnt_been_used =
      User.primary_or_secondary_email_already_used?(self.email).empty?

      if !self.secondary_email.nil? and self.secondary_email.empty?
        self.secondary_email = nil
      end

      secondary_email_hasnt_been_used =
      User.primary_or_secondary_email_already_used?(self.secondary_email).
      empty?

      if !primary_email_hasnt_been_used or !secondary_email_hasnt_been_used
        self.errors.add(:base, _("E-mail or secondary e-mail already taken."))
      end
    end
  end

  def secondary_email_format
    if !self.secondary_email.nil? and self.secondary_email.length > 0
      test = /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

      unless test.match(self.secondary_email)
        self.errors.add(:base, _("Invalid secondary email format."))
      end
    end
  end

  private

  def valid_format?(value, string_format)
    !value.nil? && value.length > 0 && !string_format.match(value).nil?
  end
end
