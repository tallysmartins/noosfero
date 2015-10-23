module Entities
  class SoftwareInfo < Noosfero::API::Entity
    expose :id, :finality, :repository_link, :public_software
  end

  class SoftwareCommunity < Noosfero::API::Entity
    root 'softwares', 'software'
    expose :community, :using => Noosfero::API::Entities::Community  do |community, options|
      community
    end
    expose :software_info, :using => SoftwareInfo
  end

end
