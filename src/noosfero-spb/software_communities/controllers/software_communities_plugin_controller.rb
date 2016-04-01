# apenas software
require 'csv'
class SoftwareCommunitiesPluginController < ApplicationController

  def get_license_data
    return render :json=>{} if !request.xhr? || params[:query].nil?

    data = SoftwareCommunitiesPlugin::LicenseHelper.find_licenses(params[:query]) if params[:query]
    data ||= SoftwareCommunitiesPlugin::LicenseInfo.all

    render :json=> data.collect { |license|
      {:id=>license.id, :label=>license.version}
    }

  end

  def get_field_data
    condition = !request.xhr? || params[:query].nil? || params[:field].nil?
    return render :json=>{} if condition

    model = get_model_by_params_field

    data = model.where("name ILIKE ?", "%#{params[:query]}%").select("id, name")
    .collect { |db|
      {:id=>db.id, :label=>db.name}
    }

    other = [model.select("id, name").last].collect { |db|
      {:id=>db.id, :label=>db.name}
    }

    # Always has other in the list
    data |= other

    render :json=> data
  end

  protected

  def get_model_by_params_field
    return SoftwareCommunitiesPlugin::DatabaseDescription unless params[:field] == "software_language"
    return SoftwareCommunitiesPlugin::ProgrammingLanguage
  end
end
