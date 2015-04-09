# apenas software
require 'csv'
class SoftwareCommunitiesPluginController < ApplicationController

  def get_license_data
    return render :json=>{} if !request.xhr? || params[:query].nil?

    data = if params[:query].empty?
      LicenseInfo.all
    else
      LicenseInfo.where("version ILIKE ?", "%#{params[:query]}%").select("id, version")
    end

    render :json=> data.collect { |license|
      {:id=>license.id, :label=>license.version}
    }
  end

  def get_block_template
    render 'box_organizer/_download_list_template', :layout => false
  end

  protected

  def get_model_by_params_field
    case params[:field]
    when "software_language"
      return ProgrammingLanguage
    else
      return DatabaseDescription
    end
  end
end
