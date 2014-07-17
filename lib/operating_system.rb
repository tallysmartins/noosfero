class OperatingSystem < ActiveRecord::Base
  attr_accessible :version

  belongs_to :software_info
  belongs_to :operating_system_name

  validates :version, :operating_system_name, :presence=>true
end