class PrivateInstitution < Institution
  validates :cnpj, :presence=>true, :uniqueness=>true
  validates_format_of :cnpj, :with => /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/
end