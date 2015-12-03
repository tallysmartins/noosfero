module Entities
  class SoftwareInfo < Noosfero::API::Entity
    root 'software_infos', 'software_info'
    expose :id, :finality, :repository_link, :public_software, :acronym, :objectives,
                :features,:license_info, :software_languages, :software_databases, :operating_system_names
    expose :community_id do |software_info,options|
      software_info.community.id
    end
  end
end
