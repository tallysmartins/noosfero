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

  def download_file
    download_block = Block.find(params[:block_id])

    file_link = DownloadFileHelper.get_file_link(download_block, params[:link_index].to_i)
    file = DownloadFileHelper.get_file(file_link)

    owner = download_block.owner
    download_software = owner.software_info
    download_software.download_counter += 1

    if not file.nil?
      file_body = send_file file.full_filename

      self.response.body = Enumerator::new do |enum|
        file_body.each {|file_data| enum << file_data}

        # Only save when the download is finished
        download_software.save!
      end
    else
      download_software.save!

      # If it is not in noosfero(like a external link),
      # just send the user to this location
      redirect_to file_link
    end
  end

  def hide_registration_incomplete_percentage
    response = false

    if request.xhr? && params[:hide]
      session[:hide_incomplete_percentage] = true
      response = session[:hide_incomplete_percentage]
    end

    render :json=>response.to_json
  end

  def create_institution
    @show_sisp_field = environment.admins.include?(current_user.person)
    @state_list = get_state_list()
>>>>>>> e8d6ff3... Retrive version logic.

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
    case params[:field]
    when "software_language"
      return ProgrammingLanguage
    else
      return DatabaseDescription
    end
  end
end
