class OperatingSystem < ActiveRecord::Base
  attr_accessible :version

  belongs_to :software_info
  belongs_to :operating_system_name

  validates_length_of :version, maximum: 20, too_long: _("Operating system is too long (maximum is 20 characters)")

  validates :version, :operating_system_name, :presence=>true
end