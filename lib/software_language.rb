class SoftwareLanguage < ActiveRecord::Base
  attr_accessible :version, :operating_system
  
  belongs_to :software_info
  belongs_to :programming_language

  validates_length_of :version, maximum: 20, too_long: _("Software language is too long (maximum is 20 characters)")
  validates_length_of :operating_system, maximum: 20, too_long: _("Software language is too long (maximum is 20 characters)")

  validates_presence_of :version,:programming_language,:operating_system
end
