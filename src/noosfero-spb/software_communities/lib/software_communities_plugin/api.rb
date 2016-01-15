require File.dirname(__FILE__) + '/../../../../../lib/noosfero/api/helpers'
require_relative 'api_entities'

class SoftwareCommunitiesPlugin::API < Grape::API

  include Noosfero::API::APIHelpers

  resource :software_communities do
    get do
      authenticate!
      softwares = select_filtered_collection_of(environment,'communities',params).joins(:software_info)
      softwares = softwares.visible_for_person(current_person)
      present softwares.map{|o|o.software_info}, :with => Entities::SoftwareInfo
    end

    get ':id' do
      authenticate!
      software = SoftwareInfo.find_by_id(params[:id])
      present software, :with => Entities::SoftwareInfo
    end

  end
end

