# encoding: utf-8

require_dependency 'person'

class Person

  delegate :login, :to => :user, :prefix => true

  def institutions
    institutions = []
    unless self.user.institutions.nil?
      self.user.institutions.each do |institution|
        institutions << institution.name
      end
    end
    institutions
  end

  def software?
    false
  end

  def softwares
    softwares = []
    self.communities.each do |community|
      if community.software?
        softwares << community
      end
    end

    softwares
  end

end
