class DatabaseDescription < ActiveRecord::Base
  attr_accessible :name

  has_many :software_databases
  has_many :software_infos, :through => :software_databases

  validates_presence_of :name
  validates_uniqueness_of :name

end
