# encoding: utf-8

require_dependency 'person'

class Person

  delegate :login, :to => :user, :prefix => true

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
