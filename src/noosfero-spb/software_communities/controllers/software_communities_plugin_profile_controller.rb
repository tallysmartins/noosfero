class SoftwareCommunitiesPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  before_filter :validate_download_params, only: [:download_file]

  ERROR_MESSAGES = {
    :not_found => _("Could not find the download file"),
    :invalid_params => _("Invalid download params")
  }

  def download_file
    download = SoftwareCommunitiesPlugin::Download.where(:id => params[:download_id].to_i).detect{ |b| b.download_block.environment.id == environment.id }

    if download
      download.total_downloads += 1
      download.save

      redirect_to download.link
    else
      session[:notice] = ERROR_MESSAGES[:not_found]
      render_not_found
    end
  end

  private

  def validate_download_params
    valid_block = (!params[:block_id].nil?) and (params[:block_id].to_i > 0)
    valid_index = params[:download_id].to_i >= 0

    if !valid_block or !valid_index
      session[:notice] = ERROR_MESSAGES[:invalid_params]
      safe_redirect_back
    end
  end

  def safe_redirect_back
    begin
      redirect_to :back
    rescue ActionController::RedirectBackError
      # There is no :back if it is a copied url
      render_not_found
    end
  end
end
