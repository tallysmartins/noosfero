require File.dirname(__FILE__) + '/../../../../../lib/noosfero/api/helpers'
require_relative 'api_entities'

class SoftwareCommunitiesPlugin::API < Grape::API

  include Noosfero::API::APIHelpers

  resource :software_communities do
    get do
      authenticate!
      softwares = select_filtered_collection_of(environment,'communities',params).joins(:software_info)
      present softwares, :with => Entities::SoftwareCommunity
    end

    get ':id' do
      authenticate!
      software = SoftwareInfo.find_by_id(params[:id])
      present software.community, :with => Entities::SoftwareCommunity
    end

  end
end

