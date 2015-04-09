require_dependency 'community'

class Community
  has_one :institution, :dependent=>:destroy


  def institution?
    return !institution.nil?
  end
end
