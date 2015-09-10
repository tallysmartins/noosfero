class PrivateInstitution < Institution
  validates :cnpj, :allow_nil=>true, :allow_blank=>true
end
