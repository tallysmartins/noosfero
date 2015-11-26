module Entities
  class Institution < Noosfero::API::Entity
    root 'institutions', 'institution'
    expose :name, :acronym, :unit_code, :parent_code, :unit_type,
                  :sub_juridical_nature, :normalization_level,
                  :version, :cnpj, :type, :governmental_power,
                  :governmental_sphere, :sisp, :juridical_nature,
                  :corporate_name, :siorg_code, :id
    expose :community_id do |institution,options|
      institution.community.id
    end
  end
end
