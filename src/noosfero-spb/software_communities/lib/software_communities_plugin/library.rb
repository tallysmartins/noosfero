class SoftwareCommunitiesPlugin::Library < ActiveRecord::Base
  attr_accessible :name, :version, :license, :software_info_id

  validates :name, :version, :license,
            presence: { message: _("can't be blank") },
            length: {
              maximum: 20,
              too_long: _("Too long (maximum is 20 characters)")
            }
end
