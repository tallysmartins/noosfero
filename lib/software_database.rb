class SoftwareDatabase < ActiveRecord::Base
  attr_accessible :version, :operating_system

  belongs_to :software_info
  belongs_to :database_description

  validates_length_of :version, maximum: 20, too_long: _("Software database is too long (maximum is 20 characters)")
  validates_length_of :operating_system, maximum: 20, too_long: _("Software database is too long (maximum is 20 characters)")

  validates_presence_of :database_description_id, :version, :operating_system

end
