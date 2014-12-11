class OperatingSystem < ActiveRecord::Base
  attr_accessible :version

  belongs_to :software_info
  belongs_to :operating_system_name

  validates :operating_system_name, presence: true
  validates :version,
            presence: true,
            length: {
              maximum: 20,
              too_long: _('too long (maximum is 20 characters)')
            }
end
