class PublicInstitution < Institution
  validates :governmental_power, :governmental_sphere, :juridical_nature,
            :presence=>true

  validates :acronym, :allow_blank => true, :allow_nil => true,
            :uniqueness=>true

  validates :cnpj, :uniqueness=>true

  validates_format_of(
    :cnpj,
    :with => /^\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}$/,
    :allow_nil => true, :allow_blank => true
  )
end
