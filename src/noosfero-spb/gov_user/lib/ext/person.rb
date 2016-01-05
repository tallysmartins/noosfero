# encoding: utf-8

require_dependency 'person'

class Person

  settings_items :percentage_incomplete, :type => :string, :default => ""

  attr_accessible :percentage_incomplete

  delegate :login, :to => :user, :prefix => true

  def institution?
    false
  end

  def institutions
    institutions = []
    unless self.user.institutions.nil?
      self.user.institutions.each do |institution|
        institutions << institution.name
      end
    end
    institutions
  end

end
