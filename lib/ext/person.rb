# encoding: utf-8

require_dependency 'person'

class Person

  settings_items :percentage_incomplete, :type => :string, :default => ""

  attr_accessible :percentage_incomplete

  delegate :login, :to => :user, :prefix => true

  def secondary_email
    self.user.secondary_email unless self.user.nil?
  end

  def secondary_email= value
    self.user.secondary_email = value unless self.user.nil?
  end

end
