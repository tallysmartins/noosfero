class SoftwareCommunitiesPluginProfileController < ProfileController
  append_view_path File.join(File.dirname(__FILE__) + '/../views')

  before_filter :validate_download_params, only: [:download_file]

  ERROR_MESSAGES = {
    :not_found => _("Could not find the download file"),
    :invalid_params => _("Invalid download params")
  }

  def download_file
    download_block = DownloadBlock.find_by_id params[:block]
    index = params[:download_index].to_i

    if download_block and (index < download_block.downloads.size)
      download = Download.new(download_block.downloads[index])

      download.total_downloads += 1
      download_block.downloads[index] = download.to_hash
      download_block.save

      redirect_to download.link
    else
      session[:notice] = ERROR_MESSAGES[:not_found]
      render_not_found
    end
  end

  private

  def validate_download_params
    valid_block = (!params[:block].nil?) and (params[:block].to_i > 0)
    valid_index = params[:download_index].to_i >= 0

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
