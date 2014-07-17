class PublicInstitution < Institution
  validates :acronym, :governmental_power, :governmental_sphere, :presence=>true
  validates_uniqueness_of :cnpj, :unit_code, :allow_nil => true, :allow_blank => true
  validates_format_of :cnpj, :with => /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/, :allow_nil => true, :allow_blank => true
end