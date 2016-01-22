class PublicInstitution < Institution
  validates :governmental_power, :governmental_sphere, :juridical_nature,
            :presence=>true, :unless=>lambda{self.community.country != "BR"}

  validates :cnpj,
            :format => {with: CNPJ_FORMAT},
            :unless => 'cnpj.blank?'
end
