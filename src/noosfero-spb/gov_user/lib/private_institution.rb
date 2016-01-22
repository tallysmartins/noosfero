class PrivateInstitution < Institution
  validates :cnpj,
            :format => {with: CNPJ_FORMAT},
            :if => :is_a_brazilian_institution?

  validates :cnpj,
            :uniqueness => true, :unless => 'cnpj.blank?'

  private
    def is_a_brazilian_institution?
      self.community.country == "BR"
    end
end
