class JuridicalNature < ActiveRecord::Base
  attr_accessible :name

  has_many :institutions

  validates_presence_of :name
  validates_uniqueness_of :name
end
