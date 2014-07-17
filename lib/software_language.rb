class SoftwareLanguage < ActiveRecord::Base
  attr_accessible :version, :operating_system
  
  belongs_to :software_info
  belongs_to :programming_language

  validates_presence_of :version,:programming_language,:operating_system
end
