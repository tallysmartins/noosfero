class PrivateInstitution < Institution
  validates :cnpj, :uniqueness=>true, :allow_nil=>true, :allow_blank=>true
end
