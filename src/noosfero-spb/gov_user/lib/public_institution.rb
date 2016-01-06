class PublicInstitution < Institution
  validates :governmental_power, :governmental_sphere, :juridical_nature,
            :presence=>true

  validates :cnpj,
            :format => {with: CNPJ_FORMAT},
            :unless => 'cnpj.blank?'
end
