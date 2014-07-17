class SoftwareDatabase < ActiveRecord::Base
  attr_accessible :version, :operating_system

  belongs_to :software_info
  belongs_to :database_description

  validates_presence_of :database_description_id, :version, :operating_system

end
