require_dependency 'user'

class User

  has_and_belongs_to_many :institutions

end
