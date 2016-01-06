module Entities

  class LicenseInfo < Noosfero::API::Entity
    expose :version
    expose :link
  end

  class SoftwareInfo < Noosfero::API::Entity
    root 'software_infos', 'software_info'
    expose :id
    expose :finality
    expose :repository_link
    expose :public_software
    expose :acronym
    expose :objectives
    expose :features
    expose :license_info, :using => LicenseInfo
    expose :software_languages
    expose :software_databases
    expose :operating_system_names
    expose :community_id do |software_info,options|
      software_info.community.id
    end
  end

end
