require File.dirname(__FILE__) + '/../../../../../lib/noosfero/api/helpers'
require_relative 'api_entities'

class GovUserPlugin::API < Grape::API

  include Noosfero::API::APIHelpers

  resource :gov_user do
    get 'institutions' do
      authenticate!
      institutions = select_filtered_collection_of(environment,'communities',params).joins(:institution)
      present institutions.map{|o|o.institution}, :with => Entities::Institution
    end

    get 'institutions/:id' do
      authenticate!
      institution = Institution.find_by_id(params[:id])
      present institution, :with => Entities::Institution
    end

  end
end

